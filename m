Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B6E36A9D0
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 01:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhDYXKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 19:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhDYXKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 19:10:33 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B03CC061574;
        Sun, 25 Apr 2021 16:09:51 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id n2so81620916ejy.7;
        Sun, 25 Apr 2021 16:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=u7D/ojmJZ37qasgr7Ko9GU5a0zvdevz01nK5apvh4RE=;
        b=BE3Y2Z28M//i3DE+n3QnN7qhcdrchjDJ/Pv3aW0o99XTAmwCFw/PGw/2oEl6zGMwxL
         xkZcoX3Sest8iNkheQVme90JoU9NwzN02iFbH5YR5t0NOMtB4p5p3c+APfGyxGNjCTPP
         DUm7P/0713KSwig6wcsmuotI70bFZvUp1slzyORM8+zdkTF91uF2RU4zI0lgUH/dPFUd
         yBe7IREVK56fDG2a6unOfPqnTQenPTHNIKj1X6HsYUNoynyflGw4xwp1dynib90/ZZNE
         gbkyoy9SfRFVHfdUn4bMUOfOp2/22keHljw9srrTSV2Js2BMHgpKmz0S5QBH9x7o/tm7
         Md3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=u7D/ojmJZ37qasgr7Ko9GU5a0zvdevz01nK5apvh4RE=;
        b=DwRwacdvPlNaSS9E4yDJHZ1w50R43OD4RXdhSkpJ/FkweqeYodojaK/yfxLaPgdMxd
         FAKaM4KMbSI3tC17KOC7y/FnDcZZdSUpOTOmmLeYF506DZCR2xy33AcZiisS1KhsFIIG
         InTbPV+JSErfciuxfIDB4Whmd5j/SvSzS5p7ohR+DKqZ3bOSB8Y1yIqt6KmWO9VwzsFp
         FJuqWkXvN9PJxNL7P+Fe++MY1asJEwyKczXU1c7TOQsTlVjf7SJvLcL+wc1K7e0hIuYc
         exni8+MVzgiZbWdLr1CDmZlQFSmQ947i0y0nyKNO8KzZ+8YCi7d5VFJa/ENspNvREO1g
         jctQ==
X-Gm-Message-State: AOAM5311uudB+htX+R9S2iu1OMsWK6y1gnoEk7pjsYzi+7YirtZuGOO3
        BseueX9yKsglEmg44VjBnWrIfE6GabafR4beMTU=
X-Google-Smtp-Source: ABdhPJzJNB3O+udew+sU1cP/HJky7rP4GyPFYzmHeDq+GBtvoStPTFQZQr2EtgHNhUgfT/fAxcDxdDh63rTCCM0TLoc=
X-Received: by 2002:a17:906:a449:: with SMTP id cb9mr15461269ejb.118.1619392189843;
 Sun, 25 Apr 2021 16:09:49 -0700 (PDT)
MIME-Version: 1.0
From:   Tyler S <tylerjstachecki@gmail.com>
Date:   Sun, 25 Apr 2021 19:09:39 -0400
Message-ID: <CAMfj=-YEh1ZnLB8zye7i-5Y2S015n0qat+FQ6JW7bFKwBUHBPg@mail.gmail.com>
Subject: Re: [PATCH net v2] igb: Fix XDP with PTP enabled
To:     kurt@linutronix.de
Cc:     alexander.duyck@gmail.com, anthony.l.nguyen@intel.com,
        ast@kernel.org, bigeasy@linutronix.de, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        ilias.apalodimas@linaro.org, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, lorenzo@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, sven.auhagen@voleatech.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for this work; I was having trouble using XDP on my I354 NIC until this.

Hopefully I have not err'd backporting it to 5.10 -- but I'm seeing
jumbo frames dropped after applying this (though as previously
mentioned, non-skb/full driver XDP programs do now work).

Looking at the code, I'm not sure why that is.

- Tyler
