Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF4B27D44F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgI2RS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:18:57 -0400
Received: from mx4.wp.pl ([212.77.101.12]:31529 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgI2RS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 13:18:57 -0400
Received: (wp-smtpd smtp.wp.pl 28907 invoked from network); 29 Sep 2020 19:18:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1601399933; bh=wbAXs32pZ3bQDQV1uH+M8ERsXSGLGZuUyyrIu8xDhOg=;
          h=From:To:Cc:Subject;
          b=fwk+azLTHGAmGrrbe++utWiq9I1a21lWUT79oebhJrKCz48XpISVbqakk78S4kkMK
           Hy0qNxHYb48i7U69rrhETX+kgrQazxoZRPlj/zlegCCqOia2tN8uCQsv+CDWGi8W76
           ZJkk8c6SKwwqG57ieDROfd/MSoANtHo+lfW7KI7M=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.7])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jacob.e.keller@intel.com>; 29 Sep 2020 19:18:52 +0200
Date:   Tue, 29 Sep 2020 10:18:46 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, snelson@pensando.io
Subject: Re: [RFC iproute2-next] devlink: display elapsed time during flash
 update
Message-ID: <20200929101846.2a296015@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200928234945.3417905-1-jacob.e.keller@intel.com>
References: <20200928234945.3417905-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 166c28eb58544daa53fae94e7c550943
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [YZKD]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 16:49:45 -0700 Jacob Keller wrote:
> For some devices, updating the flash can take significant time during
> operations where no status can meaningfully be reported. This can be
> somewhat confusing to a user who sees devlink appear to hang on the
> terminal waiting for the device to update.
> 
> Provide a ticking counter of the time elapsed since the previous status
> message in order to make it clear that the program is not simply stuck.
> 
> Do not display this message unless a few seconds have passed since the
> last status update. Additionally, if the previous status notification
> included a timeout, display this as part of the message. If we do not
> receive an error or a new status without that time out, replace it with
> the text "timeout reached".
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> Sending this as an RFC because I doubt this is the best implementation. For
> one, I get a weird display issue where the cursor doesn't always end up on
> the end of line in my shell.. The % display works properly, so I'm not sure
> what's wrong here.
> 
> Second, even though select should be timing out every 1/10th of a second for
> screen updates, I don't seem to get that behavior in my test. It takes about
> 8 to 10 seconds for the first elapsed time message to be displayed, and it
> updates really slowly. Is select just not that precise? I even tried using a
> timeout of zero, but this means we refresh way too often and it looks bad. I
> am not sure what is wrong here...

Strange. Did you strace it? Perhaps it's some form of output buffering?

> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index 0374175eda3d..7fb4b5ef1ebe 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -33,6 +33,7 @@
>  #include <sys/select.h>
>  #include <sys/socket.h>
>  #include <sys/types.h>
> +#include <sys/time.h>
>  #include <rt_names.h>
>  
>  #include "version.h"
> @@ -3066,6 +3067,9 @@ static int cmd_dev_info(struct dl *dl)
>  
>  struct cmd_dev_flash_status_ctx {
>  	struct dl *dl;
> +	struct timeval last_status_msg;
> +	char timeout_msg[128];

Really you just need the length (as returned by snprintf), right?

> +	uint64_t timeout;
>  	char *last_msg;
>  	char *last_component;
>  	uint8_t not_first:1,
> @@ -3083,6 +3087,14 @@ static int nullstrcmp(const char *str1, const char *str2)
>  	return str1 ? 1 : -1;
>  }
>  
> +static void cmd_dev_flash_clear_elapsed_time(struct cmd_dev_flash_status_ctx *ctx)
> +{
> +	int i;
> +
> +	for (i = 0; i < strlen(ctx->timeout_msg); i++)
> +		pr_out_tty("\b");

I wonder if it's not easier to \r, I guess the existing code likes \b
so be it.

> +}
> +
>  static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
>  {
>  	struct cmd_dev_flash_status_ctx *ctx = data;

> +static void cmd_dev_flash_time_elapsed(struct cmd_dev_flash_status_ctx *ctx)
> +{
> +	struct timeval now, res;
> +
> +	gettimeofday(&now, NULL);
> +	timersub(&now, &ctx->last_status_msg, &res);
> +
> +	/* Don't start displaying a timeout message until we've elapsed a few
> +	 * seconds...
> +	 */
> +	if (res.tv_sec > 3) {
> +		uint elapsed_m, elapsed_s;

This may be the first uint use in iproute2..

> +		/* clear the last elapsed time message, if we have one */
> +		cmd_dev_flash_clear_elapsed_time(ctx);
> +
> +		elapsed_m = res.tv_sec / 60;
> +		elapsed_s = res.tv_sec % 60;
