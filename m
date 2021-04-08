Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789103580F5
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 12:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhDHKjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 06:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbhDHKip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 06:38:45 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D09C061763
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 03:38:34 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id o11so589105qvh.11
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 03:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=+H0oQpn+vN4fQ6ZVUARxPRSp3JHN8ExZA0WJL+71VTg=;
        b=aewYBJkNUKGadss273hdLjYwLDvPYijIWpLHx7nKcKT2EKVYI0C1x9t0ggjlp+ooz/
         GojD9ApcXC2KwI6ERmnDj8jL33/nDYuDbTot7qiF28ePMsBk0Axj0yGZJWIJl6ecHV+Q
         Uup/TO3DCQEv6oSSSdFtBlr7QNI/164jxLy/RDhvrUyEACtBd1+oJvcK7/BovkQP9X+U
         77z8abMpfc9HLQV/ZG7l7PFIC7DVVj/WYw+lJZWfgXD2WfUf2SybB+zMVGdUCofDGXQa
         UbIeR377qur5RUAw9ANfhRukbLHL16oL1m0WwkuIGAcD2QHm4OLPF/ZzL04uds8YmkXS
         qHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+H0oQpn+vN4fQ6ZVUARxPRSp3JHN8ExZA0WJL+71VTg=;
        b=uT7ybPX/28/+p5HVvkFVEMVnIx+S005ECLBafHuB+BLS5VY9CqC4igYZZdiDImka0E
         N6Yn5rK9IW19hvueiz8aItRyPG5tU0fTJEKzvekUeVkcqoBWvxAfPgLeJzCcgY/6se7r
         WtaTuz2r5EOo8y+PNrAboURBoPK0GqR+FVL4/rIQ91OQ4CkBV5BT72xgKf7Fu2Lh8qDW
         WUDPFofs2mzE24N0pyY0ttuhxrzyhXqot3xz7LVlh9IMyZX1FX+490J15RiewnOthaJ6
         AZ1h7EVAZ7sSIg1RNKGhckHEERnovJY3tAd+Pziv370GoxkEbDxkRaVZCC2NEA8geAN+
         7+ow==
X-Gm-Message-State: AOAM5317Kzwg+GWZNJMEeY50B3+HVk83+0FHsUZiZx0voAjJrgG8otnC
        IRHtEk+B0TvioEQLv5hG+mPyZ2au2Mght5BEQXyHMJXhATI=
X-Google-Smtp-Source: ABdhPJzBOCYi9xln6OFFSeSbExumUKdY9NHX6EyeH8XWoDcuB/SvxNq+ugz2FoX2cSF1Tv4uKRoFnhHSDden3rHE0mQ=
X-Received: by 2002:a0c:eda7:: with SMTP id h7mr8122080qvr.26.1617878313570;
 Thu, 08 Apr 2021 03:38:33 -0700 (PDT)
MIME-Version: 1.0
From:   Kestrel seventyfour <kestrelseventyfour@gmail.com>
Date:   Thu, 8 Apr 2021 12:38:22 +0200
Message-ID: <CAE9cyGTXisAmi77-NT=P2GcXAMt3x2cLvTVEbs-qh7y-Cs5ZSw@mail.gmail.com>
Subject: Remote netlink or other solution to map 2nd SoC wlan0 device into 1st SoC?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am working on better supporting fritzbox 7490 with linux. It has an
implementation where there are two SoC on the board. 1st is lantiq
with no wifi, 2nd is ath79 with 2 wifis. The lantiq SoC has a 5 port
switch, where the 5th port is the eth 1Gb link to the ath79 SoC which
has eth0, wlan0 and wlan1 (for both 2,4 and 5ghz wifis, ath9k and
ath10k). The ath79 SoC can be booted with a linux by using mdio.
Now I wonder if there is a possibility to configure the wlan0 device
that resides on the ath79 SoC from the lantiq SoC with iw, ip,
hostapd.
I saw that there is a python implementation of remote netlink
(pyroute2), is that a solution for my issue? In the mean time for
cloud, virtualization, etc. there are so many possibilities of
networking, that I wonder if there is a way to map wlan0 from the
ath79 SoC into the lantiq SoC?
The best way would be by just configuring MAC addresses, such that the
ath79 Soc would not require an ip address and the netlink based
commands will be routed from the lantiq SoC to the ath79 Soc.
Is there anything available that allows something like that?
If a driver is needed, should it just reimplement something like
pyroute2 or are there better solutions?

Thanks in advance.
Kestrel
