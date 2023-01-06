Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BCD65FAEB
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 06:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjAFF0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 00:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjAFF0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 00:26:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752092AC4
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 21:26:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66CF6B81BF2
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3339C433EF;
        Fri,  6 Jan 2023 05:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672982768;
        bh=mFgBNYu6nhKuEKl+I0xM1i5ArSA3bgiyYjeEAyL6XhY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cmX1vT+4q1XEGFy0EqTFmZkXZIhPPGwQVoDttab50GvqBtQxv2gxAEE//MN1cnp+j
         isABkOpscui5C5iF2FSOBDDb8K0K0i/WSwsmZlyJE/xf/E1umafbgxjR5RjSNYi2ij
         LBRO3cAX8Ea8jPZzkZtPFAVLbjxP4mp+9p0vzs45k8YrfWn2IasawTlLizIV9KaW3d
         4J3ZDQeWg+5Hy1kfPMadb9832mZnEZ+oprKCHGertEwFq4d4vWuLKTZ2YnpkjjWwfp
         UenP0HF4DlPeJ5iW4JZ+LoVq1hql2ZceyCsNHePtBbyecsegtnL24hX7lzxonuw45h
         JQ6F89BGBo7jQ==
Date:   Thu, 5 Jan 2023 21:26:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Cc:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        lauro.venancio@openbossa.org, linville@tuxdriver.com,
        dokyungs@yonsei.ac.kr, jisoo.jang@yonsei.ac.kr
Subject: Re: [PATCH net] nfc: pn533: Wait for out_urb's completion in
 pn533_usb_send_frame()
Message-ID: <20230105212606.2f14e5a9@kernel.org>
In-Reply-To: <20230104121711.7809-1-linuxlovemin@yonsei.ac.kr>
References: <20230104121711.7809-1-linuxlovemin@yonsei.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Jan 2023 21:17:11 +0900 Minsuk Kang wrote:
> Fix a use-after-free that occurs in hcd when in_urb sent from
> pn533_usb_send_frame() is completed earlier than out_urb. Its callback
> frees the skb data in pn533_send_async_complete() that is used as a
> transfer buffer of out_urb. Wait before sending in_urb until the
> callback of out_urb is called. To modify the callback of out_urb alone,
> separate the complete function of out_urb and ack_urb.
> 
> Found by a modified version of syzkaller.
> 
> BUG: KASAN: use-after-free in dummy_timer
> Call Trace:
>  memcpy
>  dummy_timer
>  call_timer_fn
>  run_timer_softirq
>  __do_softirq
>  irq_exit_rcu
>  sysvec_apic_timer_interrupt

Could you add fine names and line numbers to the stack trace
(use scripts/decode_stacktrace.sh)?  dummy_timer is a very generic
name, it'd be useful to tie it to the gadget device via file name.

> Fixes: c46ee38620a2 ("NFC: pn533: add NXP pn533 nfc device driver")
> Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
> ---
>  drivers/nfc/pn533/usb.c | 37 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
> index 6f71ac72012e..325818fbaf3b 100644
> --- a/drivers/nfc/pn533/usb.c
> +++ b/drivers/nfc/pn533/usb.c
> @@ -48,6 +48,8 @@ struct pn533_usb_phy {
>  	struct usb_interface *interface;
>  
>  	struct urb *out_urb;
> +	struct completion *out_done;

Why keep this pointer for the lifetime of the device instead of putting
it on the stack? For inspiration please take a look at 
struct pn533_acr122_poweron_rdr_arg
