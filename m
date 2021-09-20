Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376344114C7
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbhITMqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbhITMqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:46:16 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DBAC061574
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 05:44:50 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id i132so13524059qke.1
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 05:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=rwyepsfXk+e118OLepqKAMOl+UdykyLbS8FI7BT8xRI=;
        b=p+EAb2l1+xq0+AcSTCYu8a9fHqoeJu9ScscnOewMZovJS62rHs6CcRlVbpGu4/5gvN
         Kn0ky0jQrO+trkMomtuBZ/NsW5htq0YZ9mVsvHEXYqt8sUxnITmv4HgEDhFm04cUOECG
         iI5/UPbxUplQDDTVymt0SiN2LUBDW8/OeOGkhb20kAitzcZpI02Orkv6VB6VIlp++FRz
         MiEUZ/mJkzaCxly65lfQieDn47u5NbvIpL748HqxJKIJiPQemZH06jkKQCqr8Brlyeyb
         9JX2sv2KOo4fjlThjGwAs2oL+Z64j8aFLdjLuMTxU81V0XQgM3YKPeCGvi0kQQ8271lu
         HRmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=rwyepsfXk+e118OLepqKAMOl+UdykyLbS8FI7BT8xRI=;
        b=YnJGKX4HmjUosxjmc7OyjD6guYkqEZ36D2LXRzKrj5d1IeMxum9xFLXx8GVxu77oPh
         PCHU3OXouO3QHBB9kwQ7TCqFXtFQA6ghklnwHzWY/847PegtRvHeZRE/v7wfajFK/D/T
         vGKOunyjrTcZFJurkqiKD6tAZmFxqyKFnPBecYsjrunSjb8kB0Mv9CAbDKB3IBYJoR37
         b6XtrLNzXcI0xmLgd7Zb2P1cJogE/jOxWlx+kS9KNE48EEk3EcYvmWOb4G+AiUESnAiy
         GkIQNGvgCFbdPGyAVXmrNMsMHrQHRAF/6lLbN4/veJJAE0r6oW+fUlKiC9LRDzj9e1lB
         a+ZA==
X-Gm-Message-State: AOAM532ytrjLVJa3oLWzlIbp+Rj/UqNoLiW9qjrmX+JX+GIh08f3e6uE
        NbrfC5+MqqytZXm5c8HYnYh3yhZg+4Fge+SA+4U=
X-Google-Smtp-Source: ABdhPJwsjNYmjw3sEZnFjpXqOtlrOFLl1rVXhaHVbeQMPE+ndOneKDI9rcyg3WogSbuoq1ojb4JNJLsCaYkZGAmxoQ0=
X-Received: by 2002:a25:b5ce:: with SMTP id d14mr30780743ybg.415.1632141889046;
 Mon, 20 Sep 2021 05:44:49 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Mon, 20 Sep 2021 14:44:38 +0200
Message-ID: <CACna6ryn-gmGm0uKEd_gfNgLkGTNdKi=J=Akz5tp4nZGcZB9gQ@mail.gmail.com>
Subject: bgmac regression: hang while probing on BCM47189
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

commit 34322615cbaa ("net: bgmac: Mask interrupts during probe")
caused a regression on my Tenda AC9 router (BCM47189 SoC that belongs
to the BCM53573 family).

Calling bgmac_chip_intrs_off() that early in a probe function - for
the *second* eth interface - simply hangs my device.

I didn't see any problems caused by not having that call in the first place=
.
A solution seems to be also to call bgmac_clk_enable() *first*.

Should that call to the bgmac_chip_intrs_off() be conditional? Or
should we reorder bgmac_chip_intrs_off() and bgmac_clk_enable()?

--=20
Rafa=C5=82
