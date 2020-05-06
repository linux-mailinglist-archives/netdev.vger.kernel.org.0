Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C861C6F8D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgEFLn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:43:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:52550 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbgEFLn5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 07:43:57 -0400
IronPort-SDR: VrDEgn8dTzHbXimEbR4MQ3rMstShoB8rbmBSitj1EQgPtb10HY2F/ut9I+KvEBUKf2RD38sxe8
 b6027XEB8sVw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 04:43:56 -0700
IronPort-SDR: 508UpujkLSzkGQIpVb2To/VnMx5ZCP5BF3weWKWFH7Flg12uE4phbQgeGeiM+DYx+NfPJjlyHO
 qe2WHAoAlcEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="407215532"
Received: from slgibson-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.33.158])
  by orsmga004.jf.intel.com with ESMTP; 06 May 2020 04:43:53 -0700
Subject: Re: [RFC PATCH bpf-next 04/13] xsk: introduce AF_XDP buffer
 allocation API
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maciej.fijalkowski@intel.com
References: <20200504113716.7930-1-bjorn.topel@gmail.com>
 <20200504113716.7930-5-bjorn.topel@gmail.com>
 <7270912e-bf1c-56ec-79d9-3893b6ea69ce@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <26bafed3-1ebc-234a-5e76-a6b9e1e0f32c@intel.com>
Date:   Wed, 6 May 2020 13:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <7270912e-bf1c-56ec-79d9-3893b6ea69ce@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-06 11:51, Maxim Mikityanskiy wrote:
> On 2020-05-04 14:37, Björn Töpel wrote:
[]
>> @@ -389,6 +390,11 @@ static void __xdp_return(void *data, struct 
>> xdp_mem_info *mem, bool napi_direct,
>>           xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
>>           xa->zc_alloc->free(xa->zc_alloc, handle);
>>           rcu_read_unlock();
>> +        break;
>> +    case MEM_TYPE_XSK_BUFF_POOL:
>> +        /* NB! Only valid from an xdp_buff! */
>> +        xsk_buff_free(xdp);
>> +        break;
> 
> I remember I asked about it, but not sure what we decided here. 
> xdp_return_buff is the only way to get in this new case, and it's called 
> only from XSK flows. Maybe it would make sense to kill this case and 
> xdp_return_buff, and call xsk_buff_free directly? It'll save some time 
> that we waste in switch-case, a function call and two parameters of 
> __xdp_return - should make everything faster. Do you think it makes sense?
>

I forgot about this! Thanks for the reminder. Yeah, that makes sense. 
Wdyt about the patch below:

From: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Date: Wed, 6 May 2020 13:39:05 +0200
Subject: [PATCH] xdp: simplify xdp_return_{frame,frame_rx_napi,buff}
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The xdp_return_{frame,frame_rx_napi,buff} function are never used,
except in xdp_convert_zc_to_xdp_frame(), by the MEM_TYPE_XSK_BUFF_POOL
memory type.

To simplify and reduce code, change so that
xdp_convert_zc_to_xdp_frame() calls xsk_buff_free() directly since the
type is know, and remove MEM_TYPE_XSK_BUFF_POOL from the switch
statement in __xdp_return() function.

Suggested-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
  net/core/xdp.c | 21 +++++++++------------
  1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 11273c976e19..7ab1f9014c5e 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -334,10 +334,11 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
   * scenarios (e.g. queue full), it is possible to return the xdp_frame
   * while still leveraging this protection.  The @napi_direct boolean
   * is used for those calls sites.  Thus, allowing for faster recycling
- * of xdp_frames/pages in those cases.
+ * of xdp_frames/pages in those cases. This path is never used by the
+ * MEM_TYPE_XSK_BUFF_POOL memory type, so it's explicitly not part of
+ * the switch-statement.
   */
-static void __xdp_return(void *data, struct xdp_mem_info *mem, bool 
napi_direct,
-			 struct xdp_buff *xdp)
+static void __xdp_return(void *data, struct xdp_mem_info *mem, bool 
napi_direct)
  {
  	struct xdp_mem_allocator *xa;
  	struct page *page;
@@ -359,33 +360,29 @@ static void __xdp_return(void *data, struct 
xdp_mem_info *mem, bool napi_direct,
  		page = virt_to_page(data); /* Assumes order0 page*/
  		put_page(page);
  		break;
-	case MEM_TYPE_XSK_BUFF_POOL:
-		/* NB! Only valid from an xdp_buff! */
-		xsk_buff_free(xdp);
-		break;
  	default:
  		/* Not possible, checked in xdp_rxq_info_reg_mem_model() */
+		WARN(1, "Incorrect XDP memory type (%d) usage", mem->type);
  		break;
  	}
  }

  void xdp_return_frame(struct xdp_frame *xdpf)
  {
-	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
+	__xdp_return(xdpf->data, &xdpf->mem, false);
  }
  EXPORT_SYMBOL_GPL(xdp_return_frame);

  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
  {
-	__xdp_return(xdpf->data, &xdpf->mem, true, NULL);
+	__xdp_return(xdpf->data, &xdpf->mem, true);
  }
  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);

  void xdp_return_buff(struct xdp_buff *xdp)
  {
-	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp);
+	__xdp_return(xdp->data, &xdp->rxq->mem, true);
  }
-EXPORT_SYMBOL_GPL(xdp_return_buff);

  /* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
  void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
@@ -466,7 +463,7 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct 
xdp_buff *xdp)
  	xdpf->metasize = metasize;
  	xdpf->mem.type = MEM_TYPE_PAGE_ORDER0;

-	xdp_return_buff(xdp);
+	xsk_buff_free(xdp);
  	return xdpf;
  }
  EXPORT_SYMBOL_GPL(xdp_convert_zc_to_xdp_frame);
-- 
2.25.1

