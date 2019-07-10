Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF7364C1A
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfGJSar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:30:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56010 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfGJSar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:30:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so3263112wmj.5
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=DWrSpBHXtoRsWDwzH7Rf+rYl5X1rkvI2R85cMRQoAwg=;
        b=wUSKNO0aFbiDtAnI9ibedagQc0/jg/gfPhlIv5mVGXRFvF4I/C2Dx1BgRkMH7qEq0F
         ZRbeKIdNC/6p4ffimsoPoesdVsav1JkgPfs4FuQE3/0HbROoEbZWRkvr4evfEarI4cdP
         b+bE1YPble/3sWcDHYkgTegTCbtQZuSuy60ovRTaXJqBf5DoPLSP6IwEVsXe313FkIaG
         y5vKRa0QT2K23NNSvhXTlijoQnM1exj3F4FGErkfh0hNGBlQNYbkciU5kYeMj0vAB8S0
         z2ZJEyL5OVzYMdxKYoW+bBfI1gvsgOmzmIDl+615YIArUpHN+FsNZErhuq8jPD+0cVxt
         O/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DWrSpBHXtoRsWDwzH7Rf+rYl5X1rkvI2R85cMRQoAwg=;
        b=esluqSBQ3dfdaC70/OEVyWm7vyfWGcmwabpENiMwUHeKf4xuIJAZneWZ6qCDTiKlY8
         6CCb8yD1HlGGHt6UaWsbZllbsqUeY8sVJdRfT3WhgsuBj0is6AJkQ9eqEFA4DyyaiRG9
         p/NpsELR2ck/++yZECz4+Co2T1lMmeI3G8QEqcrqyoMfoqh/HgRmo9NZg1GWywiVqEh3
         pFTlSIlJfYu0VkN/GfD+8cVV/pGTUzLlg6t6G5x1mipTHVvNNCYEgBYBwm0tV5fxMisA
         d8Z3NZq3iR371HZw9KQ4ZIF3dDT4gduVTFn15fWoqn6pZI2wbS/i1NXWqIPPy5eRxsog
         130A==
X-Gm-Message-State: APjAAAV4fe/HtlW6anudDbzJA4em8CRAMiCCGNbK2LnO2y9CBW1scNH9
        0FfyZ4KQ3jQug2A8BABayW3Utk1h898=
X-Google-Smtp-Source: APXvYqzu7x9qALjg1NW+L2jTU8IbIG0axkajt+RDPE2/uHXG0fkEoHic4BL6N7+5tN57nxmC28NlZg==
X-Received: by 2002:a7b:c857:: with SMTP id c23mr6876323wml.51.1562783445267;
        Wed, 10 Jul 2019 11:30:45 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id p3sm2747584wmg.15.2019.07.10.11.30.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 11:30:44 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 0/2] Fix bugs in NFP flower match offload
Date:   Wed, 10 Jul 2019 19:30:28 +0100
Message-Id: <1562783430-7031-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains bug fixes for corner cases in the match fields of
flower offloads. The patches ensure that flows that should not be
supported are not (incorrectly) offloaded. These include rules that match
on layer 3 and/or 4 data without specified ethernet or ip protocol fields.

John Hurley (2):
  nfp: flower: fix ethernet check on match fields
  nfp: flower: ensure ip protocol is specified for L4 matches

 .../net/ethernet/netronome/nfp/flower/offload.c    | 28 +++++++++-------------
 1 file changed, 11 insertions(+), 17 deletions(-)

-- 
2.7.4

