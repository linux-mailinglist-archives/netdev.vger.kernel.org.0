Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E6A557511
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiFWILy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiFWILh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:11:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B81D48886;
        Thu, 23 Jun 2022 01:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD40F61BF3;
        Thu, 23 Jun 2022 08:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DF0C341C6;
        Thu, 23 Jun 2022 08:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655971893;
        bh=EAzL+AzItBNItO3lmeAFB9T+n6tm2fZAOKmF5Za+tD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LyiRW1UCGfTLc/TKq8PmvnWmX09ScnIrlOCouUQglzDZvZ1zlvtEilVfKqkESGb2B
         MPIzacVZnO1KByoiR96bEAs9ZcZuVDAAQq2S2sIBRGg8W8oiOn76UAVpBxY0QylIES
         hi6613/YmX7bk/DejiOI/M3oGCN6pw0Gav4JvjcI=
Date:   Thu, 23 Jun 2022 10:11:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     mangosteen728 <mangosteen728@gmail.com>
Cc:     ast <ast@kernel.org>, andrii <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, daniel <daniel@iogearbox.net>,
        BigBro Young <hi.youthinker@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] bpf/samples: fix tbpf_perf_event_output cpu's bug
Message-ID: <YrQgMUaQeiwpUOcy@kroah.com>
References: <CAB8PBHLME8LcVJ3z+Rk+5wne03kPspthKXz2PpUx0cfg9dKpMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB8PBHLME8LcVJ3z+Rk+5wne03kPspthKXz2PpUx0cfg9dKpMQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 02:19:50AM +0800, mangosteen728 wrote:
> For the third parameter of this function,
> whose flags is set to 0, the perf_buffer__poll remains blocked.
> The flags value of BPF_F_CURRENT_CPU can receive the data normally.
> 
> Signed-off-by: mangosteen728 <mangosteen728@gmail.com>
> ---
>  Hi Greg KH:
>  I am sorry for the wrong patch submitted due to my network reasons
>  and causing unnecessary trouble to the audit.
>  thanks
>  mangosteen728
> 
>  samples/bpf/trace_output_kern.c | 2 +-
>  1 files changed, 1 insertion(+), 1 deletions(-)
> 
> diff --git a/samples/bpf/trace_output_kern.c b/samples/bpf/trace_output_
> kern.c
> index b64815a..926844e 100644
> --- a/samples/bpf/trace_output_kern.c
> +++ b/samples/bpf/trace_output_kern.c
> @@ -22,7 +22,7 @@ int bpf_prog1(struct pt_regs *ctx)
>   data.pid = bpf_get_current_pid_tgid();
>   data.cookie = 0x12345678;
> 
> - bpf_perf_event_output(ctx, &my_map, 0, &data, sizeof(data));
> + bpf_perf_event_output(ctx, &my_map, BPF_F_CURRENT_CPU, &data,
> sizeof(data));
> 
>   return 0;
>  }
> -- 
> 1.8.3.1

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch is malformed (tabs converted to spaces, linewrapped, etc.)
  and can not be applied.  Please read the file,
  Documentation/email-clients.txt in order to fix this.

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.

- It looks like you did not use your "real" name for the patch on either
  the Signed-off-by: line, or the From: line (both of which have to
  match).  Please read the kernel file, Documentation/SubmittingPatches
  for how to do this correctly.

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
