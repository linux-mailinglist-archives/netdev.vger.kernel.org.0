Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E552B96D6
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 16:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgKSPtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgKSPte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 10:49:34 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01990C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 07:49:34 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id f20so8570977ejz.4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 07:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=NZ83ISlBMeo+Hs58b/ptlSVFaUwJkkeVEHJJuVX5r+A=;
        b=bV03RXaNtIr5cTJObLiVJSHubZRdov0czorCnrFZbbTqyVdUu7ib/4iym63gzZFztq
         hXnIzSnLHB3SVm/A1JZNgg2MTOb4SfTnvhUkUSdGe5+5H1J97QcLqgFoNpLMSinoLcMD
         uRgTsPh5mZrvu5lXl1BTrdKGRj2uDADPwOHlRxRCenYH0lm9aPrb+AuIhAD5Gjp0R2zS
         U5Hc33kKWJN6fbdvUrlFs8ulbpeQqbhA754UHeBfSkZeGxee3Vw6CrAcOVL00DUpICPc
         GOV51sI4b8O7eGlGOc4yX1WY8Vx6lnsxUvchAPoH4co+5TUZGmXrGxX3KhroNtXuNE1z
         f/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NZ83ISlBMeo+Hs58b/ptlSVFaUwJkkeVEHJJuVX5r+A=;
        b=LWrvkyG6SUrJD3+BhHaJ+FWh+d/4fwnmuroOeuk72tv7bNwbrD/YuGXbcAaGE8Uk3e
         Unmm6wC9FIzAtL9oj4eVTOhqxOpwbPOTfnLBR3HpCsLN6XyDL6FncVHTvMfyTp1GKwGX
         yqf7e7sCgAzGd+f6QWfbqs9NrHLamEbffz0tqE4+44GxtwXXIEpKaaCcLg0JQkr0+VEz
         uTaEovWHjAviyNHAm9nGB7FIbtFufBvk0Ty8u7iCJfzRGnC2nlD0CWPXk56zXBbgZsKq
         ILFvfNPQD0ECdkHQxzErOeTPdJshfb+U9Ri0VQp/j1/tUvULpg3iFI2j3rh0Aj/gi8iW
         FCMQ==
X-Gm-Message-State: AOAM5311Xuu1E0z4etUOM9YeJBhsvnFdFPuFsgF2h1mL3pwOSOGs78Q6
        oMXkwEwEqq1OnQ2393aQxY9RTiPXcfT5Oq4fJk89MSUa1xc=
X-Google-Smtp-Source: ABdhPJypzUxwxxM6QRdK6pvcDuLoHr88Hkf9IOxb/wte35+m8sV3m5/SvPNYxlVz70V2iEpE1bPqlBWHkqqEjPPFvfE=
X-Received: by 2002:a17:906:8058:: with SMTP id x24mr29730891ejw.272.1605800971883;
 Thu, 19 Nov 2020 07:49:31 -0800 (PST)
MIME-Version: 1.0
From:   Tom Herbert <tom@herbertland.com>
Date:   Thu, 19 Nov 2020 08:49:21 -0700
Message-ID: <CALx6S353fPF=x4=yr4=a4zYCKVLfCRbFhEKr14A1mBRug7AfaA@mail.gmail.com>
Subject: Flow label persistence
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI,

A potential issue came up on v6ops list in IETF that Linux stack
changes the flow label for a connection at every RTO, this is the
feature where we change the txhash on a failing connection to try to
find a route (the flow label is derived from the txhash). The problem
with changing the flow label for a connection is that it may cause
problems when stateful middleboxes are in the path, for instance if a
flow label change causes packets for a connection to take a different
route they might be forwarded to a different stateful firewall that
didn't see the 3WHS so don't have any flow state and hence drop the
packets.

I was under the assumption that we had a sysctl that would enable
changing the txhash for a connection and the default was off so that
flow labels would be persistent for the life of the connection.
Looking at the code now, I don't see that safety net, it looks like
the defauly behavior allows changing the hash. Am I missing something?

Thanks,
Tom
