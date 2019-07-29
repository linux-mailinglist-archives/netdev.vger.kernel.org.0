Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D5579BEB
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 00:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbfG2WAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 18:00:18 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36371 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbfG2WAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 18:00:13 -0400
Received: by mail-yb1-f193.google.com with SMTP id d9so16088860ybf.3
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 15:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JHA2pAhg3Ob77kyxiSFaKwRVZmspL1LiyQCeGYPGRK8=;
        b=eDx6whAEcIywvS+pm3rVcmq3a9Tk0fKvfYI62v82Qs+tYwl1oZ9dHXlC7mt7rTDxii
         7o5qHf7OVqD/DLwIUp2/bbQKyAH785k39694FTJvhcMC8Xzc4aRcGDHwiOxjMqvfDEKC
         hz6x5V956uwtCPbRkn/A5OyhV91aCRWbPEyS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JHA2pAhg3Ob77kyxiSFaKwRVZmspL1LiyQCeGYPGRK8=;
        b=ZYC8Gvq5ZP/gaRk2aG1F4V23EQ+rB0zCST2DsM1Ih2IixaOw1duo8nYBPTRbBlANnV
         c8sdbiQqnWLM/ffRi1gW7OjOP4AA+0vbB27gbjygUmQpSjh95Z8kFDR4usHlr/WtZT84
         Kgw2Qk1EYfDbGj+MIZBhWk0534yKaxGn5nz4gMDzaPFLXmecwqQQVq2+oQzd+rtxHASp
         B1oN2fPE5D3SY5lkDiu0eBF1C5WchP2HKrD+QgsziIYC1FmKcbizRa+Oz0Nzau49QMtv
         CBapmCimIjmln0y2r1GMljzapqa29gfaPvOB5HnTQeO5KVnTcG4Z2lHPtwicldMWABBm
         Z1JA==
X-Gm-Message-State: APjAAAVjIhiQ3qG0cBnTo/IS+9Gl30S6Id0XKhuegFSutU4oiiqUsZ7D
        HbvW/20WFtQ5f/S5GJDRwTST/VSR0CXgYxngv4HFvCEO
X-Google-Smtp-Source: APXvYqxDjFZxRI7HZcIwTOHr5vOyM+vvWHzc3B/5Wm1z81hlEsfkpmdSnyg2oMSUsj0MoYldaTHEdg4Bpix2mGJYGa4=
X-Received: by 2002:a25:1204:: with SMTP id 4mr71068898ybs.137.1564437612474;
 Mon, 29 Jul 2019 15:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com> <20190729.142455.1728471766679878919.davem@davemloft.net>
In-Reply-To: <20190729.142455.1728471766679878919.davem@davemloft.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 29 Jul 2019 15:00:01 -0700
Message-ID: <CACKFLimd3aOoYExdUuXBGcTF_r4-hx3S7F8RsBUV72GzAw7SPA@mail.gmail.com>
Subject: Re: [PATCH net-next 00/16] bnxt_en: Add TPA (GRO_HW and LRO) on 57500 chips.
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 2:24 PM David Miller <davem@davemloft.net> wrote:
>
> From: Michael Chan <michael.chan@broadcom.com>
> Date: Mon, 29 Jul 2019 06:10:17 -0400
>
> > This patchset adds TPA v2 support on the 57500 chips.  TPA v2 is
> > different from the legacy TPA scheme on older chips and requires major
> > refactoring and restructuring of the existing TPA logic.  The main
> > difference is that the new TPA v2 has on-the-fly aggregation buffer
> > completions before a TPA packet is completed.  The larger aggregation
> > ID space also requires a new ID mapping logic to make it more
> > memory efficient.
>
> Series applied, but please explain something to me.
>
> I thought initially while reviewing this that patch #5 makes the series
> non-bisectable because this only includes the logic that appends new
> entries to the agg array but lacks the changes to reset the agg count
> at TPE end time (which occurs in patch #8).
>
> However I then realized that you haven't turned on the logic yet that
> can result in CMP_TYPE_RX_TPA_AGG_CMP entries in this context.
>
> Am I right?

Yes, correct.  Everything is built up incrementally and the new GRO_HW
and LRO features on the new chip can only be enabled after patch #14.

Thanks.
