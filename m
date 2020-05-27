Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4A91E4C00
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403776AbgE0Rfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391266AbgE0Rfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:35:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB4BC08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:35:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b135so10536734yba.11
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1CALB6XXCUkWXggNCnKd8yQSQ3gWzPmlgt+o3eFIIPc=;
        b=h8inMUcTI/R2exgy2GX/UE6oQCdZ/VRDXXlY0Xpy24sk4PTcTZtyzHl+oWmmnje3yO
         /fSbDVM6OnEKIMJ/OM5vwS6PdqlD3DtkpZPwr+fEEz5HA7QFxSC2INod77XZTecFFQSm
         Pq7yHaPmie2vj6PkIawQ1RXZx+DBNI2jEQfGl0o1iAF0iwK5HkyZZucdamUYi5/YHIsk
         Tylj4F0OZ0JW5/lOpzXiMwsuLcI+CTHOIzNZm9YnxpLiXIPbtRuDFWrVkCInKe0hflyu
         pCv2EE37M2Pz+/7eJzDlrIPLpWgTLSYK5GfvrQ/MblgQwsKKgxTb1FtrbhFQ7vs3p0/n
         JC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1CALB6XXCUkWXggNCnKd8yQSQ3gWzPmlgt+o3eFIIPc=;
        b=RKxFfOWXK4m9J/219nVCyiDiqTk7uwWz/okWozLEUHezTEMMrA5T+ssvhkrVah4WJN
         XotDRuKFYLNjO6ObiuP3QvA7qr3Y+e+YM5Z/fwzr79+8+Fdiz0VSTb91u7B7P1k6QqCU
         XB53nT91Yxe4JgWg7PTL+z10A4174IXbodZwU/lOGRxq03j8XhuKnyCfdfRiFZyooB/3
         hWWiIbfZXEOPLXQBbdOn8++MEOuHI0qZ3RYiCowcuXvm8OVKW3PhBz9fUnI8573aFC5H
         P6DHi6Rf1TjJvnlcsWuQhGa/Tmwy/vaOcAOwDiZ6rfd7L7rvB5gZPDmQqFI2Vq5PsFXx
         pQyQ==
X-Gm-Message-State: AOAM532cbsquBC8arI4AQo0RupDEu4PgZcTs7Cx4EezwNv7r+TaV2WE2
        MgLbmXCK/+gMlHRIkukhAFb+72M=
X-Google-Smtp-Source: ABdhPJwSbZmelIBVyWyTkZUTlbzpRaDH1hbHCdFP393Tl4Ve5WTyq/rqLKo1M7si8CuzTmc0pptWIx4=
X-Received: by 2002:a25:8202:: with SMTP id q2mr11479013ybk.243.1590600952995;
 Wed, 27 May 2020 10:35:52 -0700 (PDT)
Date:   Wed, 27 May 2020 10:35:51 -0700
In-Reply-To: <20200527170840.1768178-3-jakub@cloudflare.com>
Message-Id: <20200527173551.GE49942@google.com>
Mime-Version: 1.0
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-3-jakub@cloudflare.com>
Subject: Re: [PATCH bpf-next 2/8] flow_dissector: Pull locking up from prog
 attach callback
From:   sdf@google.com
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/27, Jakub Sitnicki wrote:
> Split out the part of attach callback that happens with attach/detach lock
> acquired. This structures the prog attach callback similar to prog detach,
> and opens up doors for moving the locking out of flow_dissector and into
> generic callbacks for attaching/detaching progs to netns in subsequent
> patches.

> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
