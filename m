Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3C14A7950
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 21:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbiBBUSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 15:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiBBUSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 15:18:33 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175ADC061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 12:18:33 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id v186so2249851ybg.1
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 12:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=FfUHJtnMrup0bTy5QIVCTjRbmyyUJk08CV6nq2NKHqg=;
        b=TLwLI1/8D+wB+/Wr0I0gHd39+JvOlc6CWnC6LZy/7NWtelzTUJ37jQyubuCUPyXQXw
         m2c4jPqDfnK1Rlkw36QQPhLf6JyHcM+bSVMYjRMsQF35Alb/hPRJnW9VgxjwSBAnLVc4
         GwPwq/QFjLpRG7YfPYB2TGOO5l6xrjdDibInCm1zP+6QDi0WOcZ6DlOROlnQUUc1ChCQ
         EDR6r9o4+3T8voDjGpsjIf2OSw49Dcj6LUQSonHlmtc0Gse4DudkA3Ng8HMi0o1NkBH4
         QFRxhYxvOhmRMp9A+Gf00OL8NIMSAMsnXNNxwSMmGgEHlzhqNPNaHuJnUDlNxD7HPb+5
         fFMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=FfUHJtnMrup0bTy5QIVCTjRbmyyUJk08CV6nq2NKHqg=;
        b=vDphqG0oyqOQ+b7JCozYDrcXTbAtGTnj6veXC41zqGsYDCT5fBibXh03cCPwxvfxx7
         /CxnKsWQgTyiMF+PedB8AwdCFXEz/UvZYhlVjeMOJce1hvq89Nc3FCrRWEF54bOdAHOv
         J80Jm3W/U4tolPy7tQg7JuNsjCXMjtNgZSonlI+e3MG/mrXXYYPv1XxWhrJDzy2zkRfK
         8bi+H4XNuiGVhUXkyWXzMKAUgoJ+ibiVyAgt50VKqmqWBhmSd4QUxCPQVdtBOxxH8Iei
         FYhFrWXB/KrAUkJ2Hl1swMSS1KtaIyADAYnhC5ZUqGwXbFioBuxdu8IuhnzQ1zYKh+Jm
         a1cQ==
X-Gm-Message-State: AOAM532YHqQ9fpuvdrSuBHEzIryFKQaeQKN5tzit8bnGsO9myguQSEcI
        NwBWZPa0Crx5d1WwrP+DrgcfMOyZtw9jlkFqHqUJO7nY
X-Google-Smtp-Source: ABdhPJyL4pIDzAMFYfRocB+O88iiha+++LBpNHA2QnoO+pdIe//+SkDgQYnCHznsEOfX2wkIS0ogi0JCDKTJMMV5ZV0=
X-Received: by 2002:a81:84:: with SMTP id 126mr2163168ywa.80.1643833112144;
 Wed, 02 Feb 2022 12:18:32 -0800 (PST)
MIME-Version: 1.0
From:   Erico Nunes <nunes.erico@gmail.com>
Date:   Wed, 2 Feb 2022 21:18:21 +0100
Message-ID: <CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com>
Subject: net: stmmac: dwmac-meson8b: interface sometimes does not come up at boot
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I've been tracking down an issue with network interfaces from
meson8b-dwmac sometimes not coming up properly at boot.
The target systems are AML-S805X-CC boards (Amlogic S805X SoC), I have
a group of them as part of a CI test farm that uses nfsroot.

After hopefully ruling out potential platform/firmware and network
issues I managed to bisect this commit in the kernel to make a big
difference:

  46f69ded988d2311e3be2e4c3898fc0edd7e6c5a net: stmmac: Use resolved
link config in mac_link_up()

With a kernel before that commit, I am able to submit hundreds of test
jobs and the boards always start the network interface properly.

After that commit, around 30% of the jobs start hitting this:

  [    2.178078] meson8b-dwmac c9410000.ethernet eth0: PHY
[0.e40908ff:08] driver [Meson GXL Internal PHY] (irq=48)
  [    2.183505] meson8b-dwmac c9410000.ethernet eth0: Register
MEM_TYPE_PAGE_POOL RxQ-0
  [    2.200784] meson8b-dwmac c9410000.ethernet eth0: No Safety
Features support found
  [    2.202713] meson8b-dwmac c9410000.ethernet eth0: PTP not supported by HW
  [    2.209825] meson8b-dwmac c9410000.ethernet eth0: configuring for
phy/rmii link mode
  [    3.762108] meson8b-dwmac c9410000.ethernet eth0: Link is Up -
100Mbps/Full - flow control off
  [    3.783162] Sending DHCP requests ...... timed out!
  [   93.680402] meson8b-dwmac c9410000.ethernet eth0: Link is Down
  [   93.685712] IP-Config: Retrying forever (NFS root)...
  [   93.756540] meson8b-dwmac c9410000.ethernet eth0: PHY
[0.e40908ff:08] driver [Meson GXL Internal PHY] (irq=48)
  [   93.763266] meson8b-dwmac c9410000.ethernet eth0: Register
MEM_TYPE_PAGE_POOL RxQ-0
  [   93.779340] meson8b-dwmac c9410000.ethernet eth0: No Safety
Features support found
  [   93.781336] meson8b-dwmac c9410000.ethernet eth0: PTP not supported by HW
  [   93.788088] meson8b-dwmac c9410000.ethernet eth0: configuring for
phy/rmii link mode
  [   93.807459] random: fast init done
  [   95.353076] meson8b-dwmac c9410000.ethernet eth0: Link is Up -
100Mbps/Full - flow control off

This still happens with a kernel from master, currently 5.17-rc2 (less
frequently but still often hit by CI test jobs).
The jobs still usually get to work after restarting the interface a
couple of times, but sometimes it takes 3-4 attempts.

Here is one example and full dmesg:
https://gitlab.freedesktop.org/enunes/mesa/-/jobs/16452399/raw

Note that DHCP does not seem to be an issue here, besides the fact
that the problem only happens since the mentioned commit under the
same setup, I did try to set up the boards to use a static ip but then
the interfaces just don't communicate at all from boot.

For test purposes I attempted to revert
46f69ded988d2311e3be2e4c3898fc0edd7e6c5a on top of master but that
does not apply trivially anymore, and by trying to revert it manually
I haven't been able to get a working interface.

Any advice on how to further debug or fix this?

Thanks

Erico
