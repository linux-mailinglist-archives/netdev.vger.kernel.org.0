Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9FBE7760
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 18:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404066AbfJ1RLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 13:11:46 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:49300 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404054AbfJ1RLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 13:11:46 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A68D19C0059;
        Mon, 28 Oct 2019 17:11:44 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 28 Oct 2019 17:11:39 +0000
Subject: Re: [PATCH net-next v2 2/6] sfc: perform XDP processing on received
 packets
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>
References: <74c15338-c13e-5b7b-9cc5-844cd9262be3@solarflare.com>
 <38a43fa5-5682-ffd9-f33e-5b7e04d50903@solarflare.com>
 <20191028173321.5254abf3@carbon>
From:   Charles McLachlan <cmclachlan@solarflare.com>
Message-ID: <094a9975-f1bb-7e44-10e4-64456f924ac9@solarflare.com>
Date:   Mon, 28 Oct 2019 17:11:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191028173321.5254abf3@carbon>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25006.003
X-TM-AS-Result: No-4.979000-8.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfvmLzc6AOD8DfHkpkyUphL9SeIjeghh/zMdQW9W2F3v/Q13
        bv/YY/bOCJxYVucS8wDdHz4vo2pp9nIfTcumHnhS5venhychcY35qGeseGYAlGMRmX5DNlXHOWj
        cBJBnam3AeooIzuqD8w7PvNgISbIMNZgeA8Gk1dbQfyKEYQc1R+qhuTPUDQDtFBNfI88/d9qInd
        s1RGmDC7VGIt+2axL7e0+8MeLMUvupGVKHYEvAH+LzNWBegCW2XC3N7C7Yzre3sNbcHjySQd0H8
        LFZNFG7MGpgBNI6BaN/qg21Le1RocwCpqF+s+Hr0MMnGNIiIfJp8+NrOShKdOWVebdh8PVLGSjj
        z+GdE3bTqm8N0iLZ9OmD8nRpu19X+MO0to7Dq/7wHX5+Q8jjw1wuriZ3P6dErIJZJbQfMXRqaM5
        LmpUkwzunJXJz8X1QftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.979000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25006.003
X-MDID: 1572282705-xn_klHGeUGjr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/10/2019 16:33, Jesper Dangaard Brouer wrote:
> On Mon, 28 Oct 2019 13:59:21 +0000
> Charles McLachlan <cmclachlan@solarflare.com> wrote:

>> +	/* No support yet for XDP metadata */
>> +	xdp_set_data_meta_invalid(&xdp);
>> +	xdp.data_end = xdp.data + rx_buf->len;
>> +	xdp.rxq = &rx_queue->xdp_rxq_info;
> 
> You can optimize this and only assign xdp_rxq_info once per NAPI.  E.g.
> if you "allocate" struct xdp_buff on the callers stack, and pass it in
> as a pointer.

Sadly, this function is about 5 levels deep from the NAPI loop, so I'm not sure 
that swapping one setting of a stack based pointer with many extra passings of 
a pointer will buy us anything. 

> 
>> +	default:
>> +		bpf_warn_invalid_xdp_action(xdp_act);
>> +		/* Fall through */
>> +	case XDP_ABORTED:
> 
> You are missing a tracepoint to catch ABORTED, e.g:
>   trace_xdp_exception(netdev, xdp_prog, xdp_act);
> 
>> +		efx_free_rx_buffers(rx_queue, rx_buf, 1);
>> +		break;
> 
> You can do a /* Fall through */ to case XDP_DROP.

but not if I put the trace_xdp_exception in as well. I think we're always going 
to need two efx_free_rx_buffers calls.

>> +	case XDP_DROP:
>> +		efx_free_rx_buffers(rx_queue, rx_buf, 1);
>> +		break;
>> +	}
>> +
>> +	return xdp_act == XDP_PASS;
>> +}

