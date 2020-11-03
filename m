Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1362A3B95
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 05:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgKCE7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 23:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgKCE7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 23:59:41 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE23BC0617A6;
        Mon,  2 Nov 2020 20:59:39 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id a200so13129536pfa.10;
        Mon, 02 Nov 2020 20:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ng/b2uJ5fl5AV3g0mm154lc0GmLr9bwgRfgZ0cC5EmM=;
        b=sZL6s5A6dfH5nO4/3xTaDDQS2HXo8SdTSLbeva3CarGB5WONwpK9F+PUGkAEeOOVjF
         0LMhiAo2PN+oYZkSSrUsFdbyTxSxrQI52Esubk/l83A4UcFdD+kemDMUqChfbd90dc9v
         PvqcEB1BMdhaMMdlGCrptyqKIehn64tEQ5mU1rxazAVcvgGe73cVH5d6Qq2GhENMfWcb
         Mh3C94/CN16TW+o6X3nuLICIEmetxbwquFto9BrVSGo/jVPPXl1qcp9+DTbmMAyvP0N8
         FCCTwSYwRbZOAPfezGJskzaEfVoZvCxZdBK4U8lZJkQLdxX1yOB1v3nJCet+xUGqD+p9
         MMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ng/b2uJ5fl5AV3g0mm154lc0GmLr9bwgRfgZ0cC5EmM=;
        b=jC0i2YrL6kaeIIpQkj2PmFFKiCSsdCZvkqDe5aCuWww9oq+PPliwQBKBsVseXWDvB/
         +hJRGDET4UDtrXoDHdY3C3EdcrqODzJB+2J/3sNMG1l3L/RLZX6FhUb/CIaeI35ukqKt
         Zw9e/dxWN6r6WWDBNL+a8zmXUtNDTd9zj4fIO2K3R1BlDmCgBR24djq+Bv7TGjXmGfbO
         baKZg1uVtyecYVc835uwtn8zvPA8HwM1OWSXlPrHBl9VY9D52wZgaYi+xDcZd/jmQvbe
         zqjbNmyIgcSBQIyDQb6/aBDo0dIyQRrZxh0e6KaAwVb99KYdLpzUL+EwLNocPWJmPkxE
         yPWA==
X-Gm-Message-State: AOAM531nsMSrp+OSGiSVqDCUUYd2JITclPQxWll/i+ul69ctYBHY6Mln
        PjRl/+kAdEd5XxT8Mk3YjWM=
X-Google-Smtp-Source: ABdhPJxfcaya/jjj1gMSPmlqgqCiAzJdXlusfWEaA+ecxl+67jLH4XH6V3JE6V9p1wNZMOQIQRbfBg==
X-Received: by 2002:a17:90a:bb18:: with SMTP id u24mr1925363pjr.85.1604379579259;
        Mon, 02 Nov 2020 20:59:39 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4055])
        by smtp.gmail.com with ESMTPSA id gz15sm1224444pjb.34.2020.11.02.20.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 20:59:38 -0800 (PST)
Date:   Mon, 2 Nov 2020 20:59:36 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 03/11] libbpf: unify and speed up BTF string
 deduplication
Message-ID: <20201103045936.hh7p7mmpf4vffkun@ast-mbp.dhcp.thefacebook.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-4-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029005902.1706310-4-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 05:58:54PM -0700, Andrii Nakryiko wrote:
> From: Andrii Nakryiko <andriin@fb.com>
> 
> Revamp BTF dedup's string deduplication to match the approach of writable BTF
> string management. This allows to transfer deduplicated strings index back to
> BTF object after deduplication without expensive extra memory copying and hash
> map re-construction. It also simplifies the code and speeds it up, because
> hashmap-based string deduplication is faster than sort + unique approach.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/btf.c | 265 +++++++++++++++++---------------------------
>  1 file changed, 99 insertions(+), 166 deletions(-)
> 
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 89fecfe5cb2b..db9331fea672 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -90,6 +90,14 @@ struct btf {
>  	struct hashmap *strs_hash;
>  	/* whether strings are already deduplicated */
>  	bool strs_deduped;
> +	/* extra indirection layer to make strings hashmap work with stable
> +	 * string offsets and ability to transparently choose between
> +	 * btf->strs_data or btf_dedup->strs_data as a source of strings.
> +	 * This is used for BTF strings dedup to transfer deduplicated strings
> +	 * data back to struct btf without re-building strings index.
> +	 */
> +	void **strs_data_ptr;

I thought one of the ideas of dedup algo was that strings were deduped first,
so there is no need to rebuild them.
Then split BTF cannot touch base BTF strings and they're immutable.
But the commit log is talking about transfer of strings and
hash map re-construction? Why split BTF would reconstruct anything?
It either finds a string in a base BTF or adds to its own strings section.
Is it all due to switch to hash? The speedup motivation is clear, but then
it sounds like that the speedup is causing all these issues.
The strings could have stayed as-is. Just a bit slower ?
