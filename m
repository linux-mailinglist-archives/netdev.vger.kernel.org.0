Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7591D2A6A35
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731395AbgKDQrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730973AbgKDQrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:47:00 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8096EC0613D3;
        Wed,  4 Nov 2020 08:47:00 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 133so17738648pfx.11;
        Wed, 04 Nov 2020 08:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4BiqyjCfkwLMqfM2F+PRcW4/yrG0vhDBPTZnaKc2B14=;
        b=SpHPN5sxujb2Z5x4hetvs4nayl573NQgBTdNr2U8tpZ0Mki6koIEMJGduNq6IMBmZd
         c0OepXoOYMaBEy6TDuWgk0truIygFka096WMYnPtaFMeXpDXz0LTRvtopH6iFigL5RvL
         8GyJZwyqnqFhy29yX9/icgtj5B+oa1XjmMo+BnmkR4v/1Gv33HvzLEXOMr2+Ml17KcMU
         ERjOsCTFeOlmDPWR+s4s+HDN7OW8M+nUd8M3VmLLxFb5w2WO84FaYZQt4Y5oTd08HNbD
         8qaHA0ZigxHamHFLQA5fA8MMJbe+nqrJXFSjBoC5t+vFInUCAFKVAdfCovF7MYPSig4a
         3lZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4BiqyjCfkwLMqfM2F+PRcW4/yrG0vhDBPTZnaKc2B14=;
        b=PcQy0ryeWQ7fSkc3liPx9GnbWbCeyensVhWluxgb5/fKCRpUa08ZiolSWD2sLBDzR4
         JrcgiS3B6W+YmsbWY7g+M2c22r7/VDlSws4KAPajIgqVoGr587YltD+ymLdLJFFrSmcW
         tl9OIcoYLoYwEpHQUJmB4QPspqno+uAETm567fm6zo+uCXLRWjnNTIkSlZPTDCX0J9dw
         v0EuEjbU+Oadi+3arHi1KA0URcW19zPYGZChuk8IzETwpMP6s5cfwOYdeT3Yh9NDoNk6
         GsaXdmK5+3b3DKt664xhLgkeDOilxjgAjX7Fi6l44ZM4yFbCoqcgYGEvBD9vAPAwSGih
         ljVA==
X-Gm-Message-State: AOAM532yAJZafTwsZaOY6hiDCf0ZVydQY6LGub4FEAS6kGqwFJN6NcKJ
        HlLQr8kPlv1GcoWqw9zvP0M=
X-Google-Smtp-Source: ABdhPJxtmfifAJ9/aztbiCudxhF8tpGMkXiLbaOvoqiYQjN7WgAdCnirOAPU73KB+jfaKkszFFzG8g==
X-Received: by 2002:a63:4d0e:: with SMTP id a14mr11235349pgb.91.1604508420067;
        Wed, 04 Nov 2020 08:47:00 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id k7sm2913535pfa.184.2020.11.04.08.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:46:59 -0800 (PST)
Date:   Wed, 4 Nov 2020 08:46:57 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] ptp: idt82p33: optimize _idt82p33_adjfine
Message-ID: <20201104164657.GE16105@hoboy.vegasvil.org>
References: <1604505709-5483-1-git-send-email-min.li.xe@renesas.com>
 <1604505709-5483-3-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604505709-5483-3-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 11:01:49AM -0500, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Use div_s64 so that the neg_adj is not needed.

Back in the day, I coded the neg_adj because there was some issue with
signed 64 bit division that I can't recall now.  Either div_s64 didn't
exist or it was buggy on some archs... there was _some_ reason.

So unless you are sure that this works on all platforms, I would leave
it alone.

Thanks,
Richard


> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/ptp_idt82p33.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
> index b1528a0..e970379d 100644
> --- a/drivers/ptp/ptp_idt82p33.c
> +++ b/drivers/ptp/ptp_idt82p33.c
> @@ -320,7 +320,6 @@ static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
>  {
>  	struct idt82p33 *idt82p33 = channel->idt82p33;
>  	unsigned char buf[5] = {0};
> -	int neg_adj = 0;
>  	int err, i;
>  	s64 fcw;
>  
> @@ -340,16 +339,9 @@ static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
>  	 * FCW = -------------
>  	 *         168 * 2^4
>  	 */
> -	if (scaled_ppm < 0) {
> -		neg_adj = 1;
> -		scaled_ppm = -scaled_ppm;
> -	}
>  
>  	fcw = scaled_ppm * 244140625ULL;
> -	fcw = div_u64(fcw, 2688);
> -
> -	if (neg_adj)
> -		fcw = -fcw;
> +	fcw = div_s64(fcw, 2688);
>  
>  	for (i = 0; i < 5; i++) {
>  		buf[i] = fcw & 0xff;
> -- 
> 2.7.4
> 
