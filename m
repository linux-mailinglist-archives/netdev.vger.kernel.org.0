Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC3B19387E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgCZGUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:20:06 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33824 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgCZGUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:20:06 -0400
Received: by mail-pl1-f193.google.com with SMTP id a23so1764715plm.1;
        Wed, 25 Mar 2020 23:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+ZCGtSDMsBtgLK1oFmDORsD6pY1gZ74q25ptizguQB8=;
        b=FWSCX9RoaQ5jq6EpMd3LoviH6SdOAHmcEA6PYzCpBwgffZFdIeB6hXOSIs5S3nRHDi
         JfqyiSr7hdY4WNT4oUI8cbZhkTfI2YCmZM5N0OOxmQlHF5WB79ZDw8fH3YEHP4jdxhgy
         wtfiXRapmWdPRXd6Nl85MsTfvvNQhed+ysMCJCPgpIHM+gk0DmP+xEQKDPtnlcAAYJtk
         tquYu0kH+zA+p/xLP7sMYbFsmumvAMse+iiVzkDUA+r2bPkg0fegm+AuwcIqvI70kzPz
         nA3ob+UM3lCkJ/uAGz2FisDQukuqRCHQdyqoIat4+j2QgLr7gmibzX4E1ZKUE97Cf3I4
         jjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+ZCGtSDMsBtgLK1oFmDORsD6pY1gZ74q25ptizguQB8=;
        b=WY+yV8smVAm7Tbm0yE0tZYVwLyd8VtamApkJA4ogeU0BneyF9ZhhFWKmq7AeyU2xsm
         ZeB/Ii8UWwdfR4EfD1Z/owCg/PU0wwsh2Az8QhgzQFM+JYh1r00YmpnSkTL8CDRl/KA1
         +Rz66N+W7FS/QiL6VY8c3ZNinatJCfTGi9pXnZidgmzGHGphkOFVfDgMu4UjSl/f+wzX
         Uu4TB2Sq6yy/7cDFgzkohKvNR7Z1tD3HX+TOO+FJ2L/A3/0QotCbpy1Opvmo821Zg34e
         QVg1VA5Oy/fzIpmwwO2L1KGRAKuXL/QxHeJARn5mwinmGJg0D++J4JWgxQ2kJyDAqpYs
         A6bQ==
X-Gm-Message-State: ANhLgQ1He76+/WPwTr3SB3ecrSZw6iHFzx2BUceq5MBBt3Tj2JZ1eNpz
        rkonTkfSXLxhV3G54B7FPNL2rDqR
X-Google-Smtp-Source: ADFU+vs1UdS9a2vD4zOQ3PRbjSa5yFDnEIJ1E+cfQP39JTYVv2glbQUBdvBfQLIMKdtF7+Hl0OiSVA==
X-Received: by 2002:a17:902:ee4b:: with SMTP id 11mr6711091plo.19.1585203604879;
        Wed, 25 Mar 2020 23:20:04 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:5929])
        by smtp.gmail.com with ESMTPSA id f15sm785397pfd.215.2020.03.25.23.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 23:20:04 -0700 (PDT)
Date:   Wed, 25 Mar 2020 23:20:01 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ecree@solarflare.com, yhs@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [bpf-next PATCH 04/10] bpf: verifier, do explicit ALU32 bounds
 tracking
Message-ID: <20200326062001.3j6yqyu7jne4gtfl@ast-mbp>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
 <158507153582.15666.3091405867682349273.stgit@john-Precision-5820-Tower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158507153582.15666.3091405867682349273.stgit@john-Precision-5820-Tower>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 10:38:56AM -0700, John Fastabend wrote:
> -static void __reg_bound_offset32(struct bpf_reg_state *reg)
> +static void __reg_combine_32_into_64(struct bpf_reg_state *reg)
>  {
> -	u64 mask = 0xffffFFFF;
> -	struct tnum range = tnum_range(reg->umin_value & mask,
> -				       reg->umax_value & mask);
> -	struct tnum lo32 = tnum_cast(reg->var_off, 4);
> -	struct tnum hi32 = tnum_lshift(tnum_rshift(reg->var_off, 32), 32);
> +	/* special case when 64-bit register has upper 32-bit register
> +	 * zeroed. Typically happens after zext or <<32, >>32 sequence
> +	 * allowing us to use 32-bit bounds directly,
> +	 */
> +	if (tnum_equals_const(tnum_clear_subreg(reg->var_off), 0)) {
> +		reg->umin_value = reg->u32_min_value;
> +		reg->umax_value = reg->u32_max_value;
> +		reg->smin_value = reg->s32_min_value;
> +		reg->smax_value = reg->s32_max_value;

Looks like above will not be correct for negative s32_min/max.
When upper 32-bit are cleared and we're processing jmp32
we cannot set smax_value to s32_max_value.
Consider if (w0 s< -5)
s32_max_value == -5
which is 0xfffffffb
but upper 32 are zeros so smax_value should be (u64)0xfffffffb
and not (s64)-5

We can be fancy and precise with this logic, but I would just use similar
approach from zext_32_to_64() where the following:
+       if (reg->s32_min_value > 0)
+               reg->smin_value = reg->s32_min_value;
+       else
+               reg->smin_value = 0;
+       if (reg->s32_max_value > 0)
+               reg->smax_value = reg->s32_max_value;
+       else
+               reg->smax_value = U32_MAX;
should work for this case too ?

> +	if (BPF_SRC(insn->code) == BPF_K) {
> +		pred = is_branch_taken(dst_reg, insn->imm, opcode, is_jmp32);
> +	} else if (src_reg->type == SCALAR_VALUE && is_jmp32 && tnum_is_const(tnum_subreg(src_reg->var_off))) {
> +		pred = is_branch_taken(dst_reg, tnum_subreg(src_reg->var_off).value, opcode, is_jmp32);
> +	} else if (src_reg->type == SCALAR_VALUE && !is_jmp32 && tnum_is_const(src_reg->var_off)) {
> +		pred = is_branch_taken(dst_reg, src_reg->var_off.value, opcode, is_jmp32);
> +	}

pls wrap these lines. Way above normal.

The rest is awesome.
