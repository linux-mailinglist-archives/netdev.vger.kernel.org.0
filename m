Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EC12DFD59
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 16:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgLUPQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 10:16:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:50790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgLUPQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 10:16:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1608563762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vl0A2Nint1NzK8Ep4g4vvF4ZXCHhT/8ljndmCtaD508=;
        b=YWccyOC1BccLfrfZAfSFjO6uE2vqdZbeseyR99Ekcmec1CYK8hOA9mxJ8p2PCmnNIeO56z
        kppQfsWsz1axzdjaZuEIEaeRJ+aRMdpYIPHxQdSuS9E57euQkMNRoDYK4TXH3fFUEgQcTI
        SWX7nE5rUlgrWezZch1AnghnYup+5Sw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 10F91AD4D;
        Mon, 21 Dec 2020 15:16:02 +0000 (UTC)
Date:   Mon, 21 Dec 2020 16:16:01 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Richard Fitzgerald <rf@opensource.cirrus.com>
Cc:     rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        shuah@kernel.org, patches@opensource.cirrus.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/4] lib: vsprintf: scanf: Negative number must have
 field width > 1
Message-ID: <X+C8MeYHX0/FsPwS@alley>
References: <20201217180057.23786-1-rf@opensource.cirrus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217180057.23786-1-rf@opensource.cirrus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 2020-12-17 18:00:54, Richard Fitzgerald wrote:
> If a signed number field starts with a '-' the field width must be > 1,
> or unlimited, to allow at least one digit after the '-'.
> 
> This patch adds a check for this. If a signed field starts with '-'
> and field_width == 1 the scanf will quit.
> 
> It is ok for a signed number field to have a field width of 1 if it
> starts with a digit. In that case the single digit can be converted.

The change makes perfect sense. vsscanf() should always process only one
character when the field width is 1.

Well, it has a potential to break existing users that rely on the
broken behavior. Fortunately, there seems be only one:

	drivers/net/wireless/intel/iwlegacy/3945-mac.c: if (sscanf(buf, "%1i", &ant) != 1) {

It is used to set a device parameter: il3945_mod_params.antenna.
There are three valid values:

	enum il3945_antenna {
		IL_ANTENNA_DIVERSITY,
		IL_ANTENNA_MAIN,
		IL_ANTENNA_AUX
	};

So, we should be on the safe side.

Anyway, adding people from
get_maintainer.pl drivers/net/wireless/intel/iwlegacy/3945-mac.c
so that they are aware of this.

> Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

> ---
>  lib/vsprintf.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 14c9a6af1b23..8954ff94a53c 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -3433,8 +3433,12 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
>  		str = skip_spaces(str);
>  
>  		digit = *str;
> -		if (is_sign && digit == '-')
> +		if (is_sign && digit == '-') {
> +			if (field_width == 1)
> +				break;
> +
>  			digit = *(str + 1);
> +		}
>  
>  		if (!digit
>  		    || (base == 16 && !isxdigit(digit))
> -- 
> 2.20.1
