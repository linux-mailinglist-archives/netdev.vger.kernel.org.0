Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3FE2D1B6
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 00:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfE1WuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 18:50:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32930 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfE1WuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 18:50:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id d9so304864wrx.0
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 15:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=x9Vv2siOXrEhIRHDzVkn3APO733m5w17BFGr9BGa9Gs=;
        b=BQNw0fs7DuzKxxybc8ZX8ndw4XyvpcX9paqDE+eStr4DZX31LsnjxSVVe77mK4DMiH
         pNPHdukeU789HoEkOpuaUERM1TMPSGsl+0VkxBpSpofqYeApuop8rTB72IIE1XMvzkZe
         KLChNEadeZeOD5ulVceUV04xx0z6icN7JeIdvPsUFF4hpfpgXcYRPkP3ESxA1o3+XCtD
         b0amoaLun5q77xBKcFmadNewYAqd7DXnbfOQQERsf8l3DlrD6KFhvTa4WG0LsbEvBdx7
         AES3AuOKSCvueOK+c+wqWV/qgDTNfrUCwNFydeUH7pNe2c9szmizgV3I29LeLmdU4Dl1
         T8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x9Vv2siOXrEhIRHDzVkn3APO733m5w17BFGr9BGa9Gs=;
        b=Pn0HwyIJwj8RFB7W8sYRfz6SgDAbwj2iAAy+ejuJ3hY0R1fd/QxT8cRmdgwCgLjW+p
         HgJ4L5cWVaP18OJ8xKVeC2YF22/4pIrmtiSmglgJja2jQrdc8UIef4wLs46Id99KwfKf
         Xp0yATsfBgwJQGopkEQncmtY7kKNNONtPFNOtpM75MHxNumZFbHbV+tAUV1VKAeU0glA
         jfygSw07gnSur9z8696rh/+vmEE/MJHwlgY8GJe/lAJHg5v00AYlu3rfB6lfVuGiVdAV
         Mcaq74CKKZbSD5yVEuxQPA6IqMyWueCI0p5qyIA34mO/r6poKB82wKFmk9zeiLGKro06
         5TSQ==
X-Gm-Message-State: APjAAAX6GrXuVcpM964z2VyWotuWGgff8E0sINDr9WCLnCqg3PO5DkRX
        8oZ6W0JPDbqhNpoIz3x6eVw=
X-Google-Smtp-Source: APXvYqwadZB1szbICtIkxGygCyOyHzC8YzL6Hjr4S6HCi8osstyuT5C4DFEqSVSTLqZnlVbnQ3hUBQ==
X-Received: by 2002:adf:e584:: with SMTP id l4mr57009536wrm.54.1559083812389;
        Tue, 28 May 2019 15:50:12 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm6623658wrq.48.2019.05.28.15.50.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 15:50:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/2] Fixes for DSA tagging using 802.1Q
Date:   Wed, 29 May 2019 01:50:03 +0300
Message-Id: <20190528225005.10628-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the prototyping for the "Decoupling PHYLINK from struct
net_device" patchset, the CPU port of the sja1105 driver was moved to a
different spot.  This uncovered an issue in the tag_8021q DSA code,
which used to work by mistake - the CPU port was the last hardware port
numerically, and this was masking an ordering issue which is very likely
to be seen in other drivers that make use of 802.1Q tags.

A question was also raised whether the VID numbers bear any meaning, and
the conclusion was that they don't, at least not in an absolute sense.
The second patch defines bit fields inside the DSA 802.1Q VID so that
tcpdump can decode it unambiguously (although the meaning is now clear
even by visual inspection).

Ioana Ciornei (1):
  net: dsa: tag_8021q: Change order of rx_vid setup

Vladimir Oltean (1):
  net: dsa: tag_8021q: Create a stable binary format

 net/dsa/tag_8021q.c | 73 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 14 deletions(-)

-- 
2.17.1

