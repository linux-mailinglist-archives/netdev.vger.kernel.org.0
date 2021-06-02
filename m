Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD726399198
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhFBR16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229876AbhFBR1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 13:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6928761CFF;
        Wed,  2 Jun 2021 17:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622654769;
        bh=4TdZWdT458pa+A30aTCE5yanC9JhHWs29JrnvdhvEsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IhTSPvX1oFWdhWHvPOOW2s4vlB00wzTN1wE2o6r5VK+9bObXTr3LC66LEhfIOILVO
         OnXKWk9q28SQcFDyatOCgQyYUvVKL2himBVOIot23PfZWFuvevCSHoynsZiObqRgAw
         UrIBVx+ZKiQ8k57gL/06h7pv75aF5KJW3I4nAnhPcFfbb7VAb5ksGBZd0Z4WX0YpdQ
         jle8X/mqbZQQsDxn+kOwfTuCM5pHOLsk0jT230v0xX9tId75Q3+AtpOw+74b1mnE3B
         7mlYEE1W96v5qY6Z3urtZDUFNTejlhORoonbDlImg3Dch0yZ73lAs54uxlK/8M3oA7
         9oBvlXvUhEVTw==
Date:   Wed, 2 Jun 2021 18:26:04 +0100
From:   Will Deacon <will@kernel.org>
To:     "Xu, Yanfei" <yanfei.xu@windriver.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        zlim.lnx@gmail.com, catalin.marinas@arm.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] bpf: avoid unnecessary IPI in bpf_flush_icache
Message-ID: <20210602172603.GB31957@willie-the-truck>
References: <20210601150625.37419-1-yanfei.xu@windriver.com>
 <20210601150625.37419-2-yanfei.xu@windriver.com>
 <56cc1e25-25c3-a3da-64e3-8a1c539d685b@iogearbox.net>
 <20210601174114.GA29130@willie-the-truck>
 <7637dcdf-12b4-2861-3c76-f8a8e240a05e@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7637dcdf-12b4-2861-3c76-f8a8e240a05e@windriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 07:26:03PM +0800, Xu, Yanfei wrote:
> 
> 
> On 6/2/21 1:41 AM, Will Deacon wrote:
> > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > 
> > On Tue, Jun 01, 2021 at 07:20:04PM +0200, Daniel Borkmann wrote:
> > > On 6/1/21 5:06 PM, Yanfei Xu wrote:
> > > > It's no need to trigger IPI for keeping pipeline fresh in bpf case.
> > > 
> > > This needs a more concrete explanation/analysis on "why it is safe" to do so
> > > rather than just saying that it is not needed.
> > 
> > Agreed. You need to show how the executing thread ends up going through a
> > context synchronizing operation before jumping to the generated code if
> > the IPI here is removed.
> 
> This patch came out with I looked through ftrace codes. Ftrace modify
> the text code and don't send IPI in aarch64_insn_patch_text_nosync(). I
> mistakenly thought the bpf is same with ftrace.
> 
> But now I'm still not sure why the ftrace don't need the IPI to go
> through context synchronizing, maybe the worst situation is omit a
> tracing event?

I think ftrace handles this itself via ftrace_sync_ipi, no?

Will
