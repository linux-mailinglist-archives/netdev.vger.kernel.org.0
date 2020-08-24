Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A599E24FFE1
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 16:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgHXOfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 10:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgHXOfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 10:35:42 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D784BC061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 07:35:41 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id x9so4464325wmi.2
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 07:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intinor-se.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=PV6NInVuwM0ZFOzf5u+K0D31QYADBewwzCHAM/IfltE=;
        b=0UqxTxIpnQuB5y+UFMpBcrIwJsTK3l3i21F7K83t2PsSwdJPUDZMcaBPoFnjTZFI2/
         mxJEaLWqcck77bLm6emiuNtQKNipwosI7n0hR4DcGsyq4mdC3Pd5T+RAZ1mUSV0Gzx4r
         Z19tdWn6Mgr2ondxRJNSi5egGqHYbK+hay01hlCMOFMFo1Jb8Jg4vyQzNBeD+JaraB3Q
         tqVoy/PxauDXBILZ0UJ4fQWI1oKkt/vygA9O1jvjagAj0kRIpJrqwShvhcByo+TcAcvk
         WmTgYaZbm26FgF9ekqo5Bp5HHGPYNdFytf8ZisswtebH+bw9J52sHEqQxanPGa3ugltj
         1aPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=PV6NInVuwM0ZFOzf5u+K0D31QYADBewwzCHAM/IfltE=;
        b=tiEg0f3z3fUkPIGnQswZPmru8OZpEDbiemo1VKeCjlqWNxr7PhVTkrYmWRjqUwTZPA
         taSu+asjKO0wpI+kDP9RQf4yIJNVXGV9tPgk9D76G9zRc3esH9+XSLaSuNpYyNELCn/L
         Whw1jeiz28ozNq42gTlAkh83fgOe1gEQ91wVegmEFT45lEbdN6HF1zTq3n25jwaawpFl
         4DGbyC7SMz1xOYWooM6aL12415S0jFZMTcj+yJIDHMyJINCn2yXkfNadhABVbsUOtsub
         uD4+saT1hZBSKrNco4tiSULYL3qeS8W++a51/sCooeg+qbDpiuSFkwffovRLUJiwChHT
         uhgQ==
X-Gm-Message-State: AOAM531p2ViB9rHLaTpPg3RzD0XQs4dyINqJGk7PP1VHdyfldY4a3u5t
        CpnmJLIXJ7Wa0LGDfO/A+asKPjcgKcsgB/sCzyA2LHNR7SB9Cg==
X-Google-Smtp-Source: ABdhPJzw/FoJtoxQzgPdUYNP97ZKCCZGfUhCn2Rjfzh3yzKwvOUvbFpKgUezOiwynlbXfumuzyAZ+tIHp63hR+zFUgI=
X-Received: by 2002:a1c:7c0d:: with SMTP id x13mr5744838wmc.164.1598279740415;
 Mon, 24 Aug 2020 07:35:40 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Robert_Bengtsson=2D=C3=96lund?= 
        <robert.bengtsson-olund@intinor.se>
Date:   Mon, 24 Aug 2020 16:35:29 +0200
Message-ID: <CAM7CaVQf-xymnx8y-nn7E3N6P5=-HF2i_1XhFgp1MZB1==WZiA@mail.gmail.com>
Subject: Request for backport of 78dc70ebaa38aa303274e333be6c98eef87619e2 to 4.19.y
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone

We stumbled upon a TCP BBR throughput issue that the following change fixes=
.
git: 78dc70ebaa38aa303274e333be6c98eef87619e2

Our issue:
We have a transmission that is application limited to 20Mbps on an
ethernet connection that has ~1Gbps capacity.
Without this change our transmission seems to settle at ~3.5Mbps.

We have seen the issue on a slightly different network setup as well
between two fiber internet connections.

Due to what the mentioned commit changes we suspect some middlebox
plays with the ACK frequency in both of our cases.

Our transmission is basically an RTMP feed through ffmpeg to MistServer.

Best regards
/Robert

--=20
Robert Bengtsson-=C3=96lund, System Developer
Software Development
+46(0)90-349 39 00

www.intinor.com

-- INTINOR --
WE ARE DIREKT
