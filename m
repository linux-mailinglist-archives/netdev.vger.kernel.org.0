Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A359B300F3D
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 22:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbhAVVvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 16:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729347AbhAVVu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 16:50:56 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AD2C06174A;
        Fri, 22 Jan 2021 13:50:10 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b8so4028909plh.12;
        Fri, 22 Jan 2021 13:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xS49M72a2b/S7Fz9V9KsweEDhqR+Pq3GaKTvjEl5lTo=;
        b=ZZGHsg+tqXeE60XCB/EYVRkqTgygVmcptUIAIHwECriYYJaqC/JYzyHt3/YZzQx+ea
         Qn84U2hM2my38R/FHtL47OR2CW2ZjYy8YaGFeeLGBxLM4rjo428als/KdqcjuxQVTYwA
         QvbrfYyRS1WkN/2KAID1fAp3nUP1DG2GqpprgbvkBBiagdAYZlniQNagbzWL073vNjBl
         8QoUFnmr4GIgxce2JIASkpfcc0O5FRgQsSrVDvvPfPITujuplVSvGX839Oi0dg9am+zj
         9ov+kRrTQ40YHlf7c6eqxbPCugzxZq71TDaPBBsxs0MFUaw60s2xBKEZVfn/hBGhWVqn
         tl4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xS49M72a2b/S7Fz9V9KsweEDhqR+Pq3GaKTvjEl5lTo=;
        b=Goc+P89hLofr3j9WwzHxNzTjWls69D2sW+dKypp5ec6IBpCvJRlkssynOCMlAuoZEy
         sZjPY7zc0SLgjE1LRRMNc+/3x6xmDvFO9xkoIfun0F+AtRGHgJTV372Geo+/oT/VGKVQ
         KCqDeVorJNV5g/q0uWSR2WS9QbJgkIVfMqqaooItDqEwnh/D9nD4xXUcv/y77lVdjM8P
         9fq/gabRY5+nYVbqnBt+O/gP39WbO/nkCKUQXzvBlzLEAizdu3H86d38Q1RjQd1S+SNH
         j0jn07kkq8QScW11SZVx9V/2rQLU+tf6hNlLsa9QAOnwgnNbOc18X1NdfpWtX01+/uqG
         bH6w==
X-Gm-Message-State: AOAM531W1XCXXfjLk0WbjBbxsuz8+q1ABF9Mze/bNMyNLH4yZNcSfFdQ
        f+FB0//lSOAivuGLTztDPiYrqT4eofU51ENiSsaE+uka
X-Google-Smtp-Source: ABdhPJwIlVeyxcRVzH2KOVb6rOD+FwwF+DRNyMAfHbpkumb0dcfVk2y3yMYemr09kU2oet/6lVRncW0dhZ4G/XnIs1M=
X-Received: by 2002:a17:90a:3481:: with SMTP id p1mr7790245pjb.198.1611352209655;
 Fri, 22 Jan 2021 13:50:09 -0800 (PST)
MIME-Version: 1.0
References: <20210121002129.93754-1-xie.he.0141@gmail.com> <b42575d44fb7f5c1253635a19c3e21e2@dev.tdt.de>
In-Reply-To: <b42575d44fb7f5c1253635a19c3e21e2@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 22 Jan 2021 13:49:58 -0800
Message-ID: <CAJht_EOr99tmcm44gM=K7T6mtwkBE0TGJ0jQ8HmCE2Nx3=eqQw@mail.gmail.com>
Subject: Re: [PATCH net v5] net: lapb: Add locking to the lapb module
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 1:07 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> I don't have the opportunity to test this at the moment, but code looks
> reasonable so far. Have you tested this at runtime?

Thanks! Yes, I have tested this using hdlc_x25.c, lapbether.c and (the
deleted) x25_asy.c drivers.
