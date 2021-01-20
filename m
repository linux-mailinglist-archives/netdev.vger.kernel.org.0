Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90162FD252
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 15:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390001AbhATOGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:06:30 -0500
Received: from mga17.intel.com ([192.55.52.151]:24363 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732989AbhATN04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 08:26:56 -0500
IronPort-SDR: fN8kY5/5Rdse0r3H/wfteFAmYltvjjqETEo60YUO6hTBhkCW/MuffGVlnFnaXSbzutMRq81X22
 Ug0eaYEsYmtw==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="158877992"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="158877992"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 05:26:06 -0800
IronPort-SDR: +wlG/XMMvnA3KOlbzFVrHTxVSVlHcl7Sa0KBlXo4n9AnEsQC0RNIwgxMC/6+kaFQjDYic9iASs
 R3Y9iD66RiJw==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="384834513"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 05:26:00 -0800
Subject: Re: [PATCH bpf-next v2 4/8] xsk: register XDP sockets at bind(), and
 add new AF_XDP BPF helper
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-5-bjorn.topel@gmail.com> <878s8neprj.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <46162f5f-5b3c-903b-8b8d-7c1afc74cb05@intel.com>
Date:   Wed, 20 Jan 2021 14:25:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <878s8neprj.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 13:50, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
> 
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index c001766adcbc..bbc7d9a57262 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3836,6 +3836,12 @@ union bpf_attr {
>>    *	Return
>>    *		A pointer to a struct socket on success or NULL if the file is
>>    *		not a socket.
>> + *
>> + * long bpf_redirect_xsk(struct xdp_buff *xdp_md, u64 action)
>> + *	Description
>> + *		Redirect to the registered AF_XDP socket.
>> + *	Return
>> + *		**XDP_REDIRECT** on success, otherwise the action parameter is returned.
>>    */
> 
> I think it would be better to make the second argument a 'flags'
> argument and make values > XDP_TX invalid (like we do in
> bpf_xdp_redirect_map() now). By allowing any value as return you lose
> the ability to turn it into a flags argument later...
>

Yes, but that adds a run-time check. I prefer this non-checked version,
even though it is a bit less futureproof.


Björn
