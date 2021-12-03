Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859B94673A8
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379435AbhLCJJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:09:39 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54978 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379432AbhLCJJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 04:09:38 -0500
Received: from [IPv6:2a00:23c6:c31a:b300:1f69:1c50:5d17:c085] (unknown [IPv6:2a00:23c6:c31a:b300:1f69:1c50:5d17:c085])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 50DAB1F46C80;
        Fri,  3 Dec 2021 09:06:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1638522372; bh=Z+j7RNdzRAECv/qZtASlqhRf0zPgXMDXj95xKClTp6k=;
        h=Subject:From:To:Cc:Date:From;
        b=IcXODj3chsDxOQXdY0g4WCsZuTdLFUbNqkHiq9EUOBCXmEGAQq4wI++T3bREDsnwe
         EWgLvZrIhoMNcEgHilP/tvXeCL/bQ8t96B7ekVazv4Qbkg51V+sm8HGrzgbnHsCvWo
         qViHZSQPVAjL2aFbxGDLS2tQWoovDpDDR8xhAC/DIojGlcro0KJoctYXdmhx7qBO3f
         jTogY9xHmYmc1HdTrKxG8f/EfJvp8C0TQyczY+gzY/l9i/CSPP5pIiwBarKRr4Pt9F
         tLHveOY2UJbrabRhUvCoajGjjVH3U+vkn4NlMef/q/bI40A/8DB8sByOLC4kI1CsBF
         JeSla4HQjkJBA==
Message-ID: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
Subject: mv88e6240 configuration broken for B850v3
From:   Martyn Welch <martyn.welch@collabora.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        kernel@collabora.com
Date:   Fri, 03 Dec 2021 09:06:09 +0000
Organization: Collabora Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

I'm currently in the process of updating the GE B850v3 [1] to run a
newer kernel than the one it's currently running. 

This device (and others in the same family) use a mv88e6240 switch to
provide a number of their ethernet ports. The CPU link on the switch is
connected via a PHY, as the network port on the SoM used is exposed via
a PHY.

The ports of the B850v3 stopped working when I upgraded, bisecting
resulted in me finding that this commit was the root cause:

3be98b2d5fbc (refs/bisect/bad) net: dsa: Down cpu/dsa ports phylink
will control

I think this is causing the PHY on the mv88e6240 side of the CPU link
to be forced down in our use case.

I assume an extra check is needed here to stop that in cases like ours,
though I'm not sure what at this point. Any ideas?

Thanks in advance,

Martyn

[1]:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/imx6q-b850v3.dts
