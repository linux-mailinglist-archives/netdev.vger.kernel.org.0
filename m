Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFDBD19874E
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 00:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgC3WXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 18:23:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38970 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbgC3WXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 18:23:07 -0400
Received: by mail-pg1-f195.google.com with SMTP id g32so3318873pgb.6;
        Mon, 30 Mar 2020 15:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BiKAxLOqqm8kt9G/Q7jIDlXTD9R49LyBGIvlpIHtGUk=;
        b=n1H6m0IcP/NRpqJoT65TmwsjMnLZ6NNhmu9wgguYg1vsX177vLbDMBssdAq95d6QKD
         if61S88jSC/e+HyL2hg3ikxtDYOfm8JdeDu2Rpsvg8KbYQ51aK6Ecq78Pt/v4n8t3ObB
         sJgSWAoOjN/rzGZBQkLr+SGu2aZpEV/rUPBO3xTgD4aakVneP+syTRvagyAwnUoRCbA5
         klRu7gNiPqu3M0k2zamgqnVBzirbjMtAdlD0foYLChZyI7pIT4uF4/eSHK+RgyY2rRAQ
         5S/VTxRw89DFXq2p5xz0tf/iBPNT/6ABDyZ++/AJ1rdjxIAmipS5//Kv7KU6SVsnqc4q
         tsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BiKAxLOqqm8kt9G/Q7jIDlXTD9R49LyBGIvlpIHtGUk=;
        b=pHIsTrNWybbeFuT9Hc/cOXLUM6JPdwugMtR5Gar3EAGxSB1w3HASwQhLaBIzqOjK4M
         z0rbVyW0RM5+uqbkW6iXQQWSg4WEWr9vdaWOn6izSirRsX9xqOBQ/g+gM7MrX/O6tHCh
         9qaf81W5zN0qlKfkeZ/MIRR2NWatDrgTvuAFMzBje7BsDdBQR9xxxCM3oLVnjM7jYWeH
         FWafkU/2skdrvjMfeB4qSKiOwYYnwjxX/cchSfQ7Grz6WiHFN6qi9yKmq0TG5ZGK1jog
         6Eerk6Y9DKAV0jmWcz0S02DVwHhIA9QrVwdl2J1Fnad8T3VvOhB8YstWeT/AfwyQgdzP
         Fv7A==
X-Gm-Message-State: ANhLgQ0HRU18q+nPTKv3mUx73gbGr5fsroGKK3VPRFa+jq0HvEGvV6Pp
        Ho+qoSyTXl3wWMzzJqHQRDY=
X-Google-Smtp-Source: ADFU+vulXzuZAYYXjvBldJV1/tgm31psAgASpwxS3ocxQk6XszHbfK4Ta5cm5Z+Vy0xkQq2ywAG7nw==
X-Received: by 2002:a63:8148:: with SMTP id t69mr14370684pgd.187.1585606985764;
        Mon, 30 Mar 2020 15:23:05 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:3558])
        by smtp.gmail.com with ESMTPSA id q15sm9480935pfn.89.2020.03.30.15.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 15:23:04 -0700 (PDT)
Date:   Mon, 30 Mar 2020 15:23:02 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ecree@solarflare.com, yhs@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [bpf-next PATCH v2 2/7] bpf: verifier, do explicit ALU32 bounds
 tracking
Message-ID: <20200330222302.6fhtedyzxfaqmthl@ast-mbp.dhcp.thefacebook.com>
References: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
 <158560419880.10843.11448220440809118343.stgit@john-Precision-5820-Tower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158560419880.10843.11448220440809118343.stgit@john-Precision-5820-Tower>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 02:36:39PM -0700, John Fastabend wrote:
> +static void __scalar64_min_max_lsh(struct bpf_reg_state *dst_reg,
> +				   u64 umin_val, u64 umax_val)
> +{
> +	/* Special case <<32 because it is a common compiler pattern to zero
> +	 * upper bits by doing <<32 s>>32. In this case if 32bit bounds are
> +	 * positive we know this shift will also be positive so we can track
> +	 * bounds correctly. Otherwise we lose all sign bit information except
> +	 * what we can pick up from var_off. Perhaps we can generalize this
> +	 * later to shifts of any length.
> +	 */
> +	if (umin_val == 32 && umax_val == 32 && dst_reg->s32_max_value >= 0)
> +		dst_reg->smax_value = (s64)dst_reg->s32_max_value << 32;
> +	else
> +		dst_reg->smax_value = S64_MAX;

I fixed up above comment to say 'sign extend' instead of 'zero upper bit' and
applied.
Thanks a ton for the awesome work.
