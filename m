Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C88E8E7813
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404290AbfJ1SF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:05:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730690AbfJ1SF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:05:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83E1714885598;
        Mon, 28 Oct 2019 11:05:56 -0700 (PDT)
Date:   Mon, 28 Oct 2019 11:05:56 -0700 (PDT)
Message-Id: <20191028.110556.665626038293022035.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     cmclachlan@solarflare.com, brouer@redhat.com,
        netdev@vger.kernel.org, linux-net-drivers@solarflare.com
Subject: Re: [PATCH net-next v2 2/6] sfc: perform XDP processing on
 received packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f9de8c74-b567-ac57-b1d5-dff8ce6ff191@solarflare.com>
References: <20191028173321.5254abf3@carbon>
        <094a9975-f1bb-7e44-10e4-64456f924ac9@solarflare.com>
        <f9de8c74-b567-ac57-b1d5-dff8ce6ff191@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 11:05:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Mon, 28 Oct 2019 17:46:18 +0000

> On 28/10/2019 17:11, Charles McLachlan wrote:
>>>> +		efx_free_rx_buffers(rx_queue, rx_buf, 1);
>>>> +		break;
>>> You can do a /* Fall through */ to case XDP_DROP.
>> but not if I put the trace_xdp_exception in as well. I think we're always going 
>> to need two efx_free_rx_buffers calls.
> 
> This will probably make people scream, but I have an evil hack to deal with
>  situations like this:
> 
> 	default:
> 		bpf_warn_invalid_xdp_action(xdp_act);
> 		if (0) /* Fall further */
> 			/* Fall through */
> 	case XDP_ABORTED:
> 		trace_xdp_exception(netdev, xdp_prog, xdp_act);
> 		/* Fall through */
> 	case XDP_DROP:
> 		efx_free_rx_buffers(rx_queue, rx_buf, 1);
> 		break;
> 
> I wonder if gcc's Wimplicit-fallthrough logic can comprehend that?  Or if
>  it'll trigger -Wmisleading-indentation?

I would seriously prefer a goto to this...
