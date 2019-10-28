Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6709BE77CC
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 18:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404171AbfJ1Rq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 13:46:28 -0400
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:51292 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731878AbfJ1Rq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 13:46:28 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C9E72940054;
        Mon, 28 Oct 2019 17:46:26 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 28 Oct
 2019 17:46:21 +0000
Subject: Re: [PATCH net-next v2 2/6] sfc: perform XDP processing on received
 packets
To:     Charles McLachlan <cmclachlan@solarflare.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>
References: <74c15338-c13e-5b7b-9cc5-844cd9262be3@solarflare.com>
 <38a43fa5-5682-ffd9-f33e-5b7e04d50903@solarflare.com>
 <20191028173321.5254abf3@carbon>
 <094a9975-f1bb-7e44-10e4-64456f924ac9@solarflare.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <f9de8c74-b567-ac57-b1d5-dff8ce6ff191@solarflare.com>
Date:   Mon, 28 Oct 2019 17:46:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <094a9975-f1bb-7e44-10e4-64456f924ac9@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25006.003
X-TM-AS-Result: No-2.190100-8.000000-10
X-TMASE-MatchedRID: cgbqQT5W8hfmLzc6AOD8DfHkpkyUphL9xmJ6Bfwk3mXRLEyE6G4DRPKD
        H4hGq6yQAtF46hV6z7l7T7wx4sxS+0rYfGvC1HVrX77gEfDSNJwhBdUXaqx1XbxgMf9QE2ebIqm
        Bfx8U8pmAAEhDtVVmUOYLxu5+inGRvSgjMukRBnQI5rLLSVe5tH0tCKdnhB58vqq8s2MNhPCXxk
        CsDPSYDBQabjOuIvShC24oEZ6SpSlR8RAUGq/SZxhwMlrB6gTpl/fsk/SGUQVb0mlmdMFWmSRSp
        slWJr+nMz/fMtcfViVqvVUJrgGm8pVVROsIqAyn4dkWtaEht9TpSZ2gObfVi4fMZMegLDIeGU0p
        Knas+RbnCJftFZkZizYJYNFU00e7O8/z8zQ+NO3AvpLE+mvX8g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.190100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25006.003
X-MDID: 1572284787-B6EyFtL0FN57
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/10/2019 17:11, Charles McLachlan wrote:
>>> +		efx_free_rx_buffers(rx_queue, rx_buf, 1);
>>> +		break;
>> You can do a /* Fall through */ to case XDP_DROP.
> but not if I put the trace_xdp_exception in as well. I think we're always going 
> to need two efx_free_rx_buffers calls.

This will probably make people scream, but I have an evil hack to deal with
 situations like this:

	default:
		bpf_warn_invalid_xdp_action(xdp_act);
		if (0) /* Fall further */
			/* Fall through */
	case XDP_ABORTED:
		trace_xdp_exception(netdev, xdp_prog, xdp_act);
		/* Fall through */
	case XDP_DROP:
		efx_free_rx_buffers(rx_queue, rx_buf, 1);
		break;

I wonder if gcc's Wimplicit-fallthrough logic can comprehend that?  Or if
 it'll trigger -Wmisleading-indentation?

-Ed
