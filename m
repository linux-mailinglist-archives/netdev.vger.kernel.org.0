Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289B6131B44
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgAFWY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:24:58 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40638 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAFWY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:24:58 -0500
Received: by mail-pf1-f195.google.com with SMTP id q8so27582538pfh.7;
        Mon, 06 Jan 2020 14:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7FdarFEm8UZ45SG7Jc44ZflZoN8XveCp2/wpvikNMsQ=;
        b=XQKOzmWyCWDk514YGteRMVLYM+OhXlMC7BAtUchaLkd18KsUegXGVZ9zeFL9XA+Lr1
         PQK9Kpbb9zXmL+Ar6BKJHORR/wQPf1TpfhhJ2mrgl1YQUHkQeh//dsNZek68fdPT1NL+
         fO9CAQoR1+aiiw0/Ffgs5HfoSzSkREmdOTl0z60n396ZhhSnQXjmfg+/+IGXZkkY1bV9
         AQHc7KY47dR6wJNFFCmgS3D70EEl6wUojlht1bmDum1eDV6VTD9nyeI8DmqEbIMf2NT9
         S//7ERXqzskxkYN2ViH+PooMghZcCmI7rcyx0bph2m9yqXyILG+CZ1pTbQCtULGBxOhf
         oXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7FdarFEm8UZ45SG7Jc44ZflZoN8XveCp2/wpvikNMsQ=;
        b=nEeEURkw/LC6QWgG/NZ0RvYt5ffnZizykOLiM7IC/ZDRE4/9Xi0iGSNjF/cQpu9yi6
         k/XNSjTmBMc4B1cCVwLzqBk16/UqP852vKflPLd7VyuJoKLKtVbM4RnX1wUOlGrBD59p
         ID9IfvhSYMTDPKja2RsHQc94d6kqYJyWh30b49jhz08hzxX04BaSRZGS6y6G5ud5/sKK
         K3gnDCOgIo7OYXFl4dHWjAkfH9U3wQ6d7ZlsnjMCFj0iSJaUgi37qXIHiccb4YRoABDu
         n2bENIbD/VP0ME51yE6k8+QtVp/wDfpFc+5DJ7NzRQ0KsXyO85Zl4Jx399aK+ecl/WrG
         ew9g==
X-Gm-Message-State: APjAAAX4g2oqEB3Dn2Iu8hukWBN5HFrRy76fD8mqK/CD+BiaDQBMHDBl
        s8tUlUN9+bKzHTjnbQrOwWW5IuaJ
X-Google-Smtp-Source: APXvYqyVPohgs+oGxZGNS0el6auiDkfRO8/RD30+5H3TjyT8OHDMxyUcESl/EWW9UT53y1GecgnTAA==
X-Received: by 2002:a62:aa03:: with SMTP id e3mr103604557pff.61.1578349497624;
        Mon, 06 Jan 2020 14:24:57 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::1:2bf6])
        by smtp.gmail.com with ESMTPSA id m15sm72995454pgi.91.2020.01.06.14.24.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 14:24:56 -0800 (PST)
Date:   Mon, 6 Jan 2020 14:24:55 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        anatoly.trosinenko@gmail.com
Subject: Re: [PATCH bpf] bpf: Fix passing modified ctx to ld/abs/ind
 instruction
Message-ID: <20200106222454.6ajkzw4s2vfq2mye@ast-mbp>
References: <20200106215157.3553-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106215157.3553-1-daniel@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 10:51:57PM +0100, Daniel Borkmann wrote:
> Anatoly has been fuzzing with kBdysch harness and reported a KASAN
> slab oob in one of the outcomes:
> 
> After further debugging, turns out while in case of other helper functions
> we disallow passing modified ctx, the special case of ld/abs/ind instruction
> which has similar semantics (except r6 being the ctx argument) is missing
> such check. Modified ctx is impossible here as bpf_skb_load_helper_8_no_cache()
> and others are expecting skb fields in original position, hence, add
> check_ctx_reg() to reject any modified ctx. Issue was first introduced back
> in f1174f77b50c ("bpf/verifier: rework value tracking").
> 
> Fixes: f1174f77b50c ("bpf/verifier: rework value tracking")
> Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Applied, Thanks
