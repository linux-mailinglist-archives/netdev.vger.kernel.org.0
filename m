Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FC245B233
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhKXCwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhKXCwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:52:01 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396E6C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 18:48:52 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id 14so1315655ioe.2
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 18:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8zo3jQFB38KQoF+t7vnzrjba+190VrTFKGiIJPy0eHg=;
        b=RpEnLq0M0xPBok8TRbGon3haEGubNmnw48t3ntHt7R6ITwB/u5xy49J3lewK7bmdIi
         ltDtSfuMpC/K7Z4luORbHKqik7cTtB4yFsptAELZySTbkmjm/qwK41RIX3ioy8rRHkeX
         HNQH9TkhFg/1m71ajGQ+JZ+Qm1wck56FX3wPWLSY2V+N3gGacH/iDV7fHLalgWvxZFCZ
         C33KePxyn2XoMZpIcGYq+Pk7B7IO7Hs44mQ7XtOMF2p2+PaC4ZUR9KsPmQrRYJeigyG8
         3lfqSfcxxB88K+TMHEi7K29hURApWohPRPu/iUbqNPIVeitQSGeypElfqrXTWGTEIqls
         Btpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8zo3jQFB38KQoF+t7vnzrjba+190VrTFKGiIJPy0eHg=;
        b=4ryDVPx63yfNinzAhcWugMgJCGd305fMVjiuTvhvodNSYjAo65FSXcT5lG0XUuJVdQ
         V0qHLn3VxHVBgp807kVdW8DRCG66XG1jpeFjqQL1WdGcoK8w63jG40FJN3Nvg8hiZMES
         9MW2BK+E8MgbWizu13lIia2ui+xQ7Gdv0njO64hJlmSvxkTmjOBYMfMeB4613WDRmElv
         QZm/5RwXTZjPzRs93T2qjK/tto3VAUhJAqqqyGyxaeRnUk+I3XTl6kt73c+hB+MJRoL3
         bIiw+mGGjwt19DlNTRGibfiAAs/KkIe463BSU2LHqwMoDY0az9HBH3K0YvtHddBOfzZt
         a41Q==
X-Gm-Message-State: AOAM533esi+pnEiScCwltI7JHjMpiTRQQliPcTVr4hU0/c7zgVG1gXyP
        NcEH5Q7DfqeUgEjc1jzceC+9fNi8ONCA+OByJPqWfPE1Kmk=
X-Google-Smtp-Source: ABdhPJzZkfKBeIyWB5tWx7ZfcBdcTAx7cb0LzxAGZSWLGBywLFQgq3b1SUqRDbECJnfSZ2/qIC5iu1P7CwAjWZMx9Cg=
X-Received: by 2002:a05:6638:2689:: with SMTP id o9mr11452289jat.83.1637722131249;
 Tue, 23 Nov 2021 18:48:51 -0800 (PST)
MIME-Version: 1.0
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 23 Nov 2021 18:48:38 -0800
Message-ID: <CAA93jw7hD6ajkCv3Q-CSM=TTcU9+tu-shTAtX=XRAFdpH5S_fQ@mail.gmail.com>
Subject: RFC: is sch_cake fully baked?
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since its incorporation in linux mainline a few years ago sch_cake has
been migrating into various other niches, like mikrotik, and finding
new uses in middleware outside our original home gateway intent.

The feature set has been stable a long while, aside from ongoing
experimentation with L4S and SCE. It's been great to leverage
continued improvements in the flow dissector in particular.

Our biggest end-user request has been to speed it up somehow,
especially for inbound shaping. The most frequent suggestion on that
front is to somehow make it multi-core, but no-one in the cake team
knows how to do that. Other means of speeding it up, like using XPF
and XDP, have recently appeared in things like
https://github.com/rchac/LibreQoS .

If anyone has thoughts for sch_cake's future, please hit
https://forum.openwrt.org/t/making-cake-multicore-or-other-new-features/112=
623

with suggestions?

Thx!


--=20
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
