Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C48642A67
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440018AbfFLPKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:10:15 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:37981 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436492AbfFLPKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 11:10:15 -0400
Received: by mail-pg1-f178.google.com with SMTP id v11so9077067pgl.5
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 08:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=yHeV3Lzac5p3sGJ4yIBFOhgl5bzVmsaCMUNYFcwMdsY=;
        b=gvGQ7MJBk6tinMUObTPVU5xkJ/XZyCa/S+dTwoqqUWgsoAHJe2sPkNwK31srRSP03I
         WxzJgThHlaAlFXwkfLLGGEl43zcedNbjsZ/a2Ce3x2KNwcpAUQHPiJdes/dzxDg3T0G3
         zeMJpMFISj0FO1ok0xNl5Qpw9xw7oqOY6MpSgYZSjnbCKPLiuwivy8HQkMQLZSIFaorx
         eSbbn6jO6Hx+I8hcxPffZYH7I1xdFV2e70fpfi1fnmdscL9yGGmOkmfIxUnI8sWJjMYg
         qck64Nejg1pkzgktarJ4tLUtbkmTWbY2P9JgDNvojCwOFNep/DHYgLPBjMmpSWGkRZrK
         2tFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=yHeV3Lzac5p3sGJ4yIBFOhgl5bzVmsaCMUNYFcwMdsY=;
        b=RSR/2StuQheWTaVfDxCm7mTenNaTHNoWbvvKF6T5htS+UeXpR08assuNzuKSUp6PIX
         Uj3s49IzwqPQE+zHvYLZOcmpq4D3kEEX7XxJB3xOTMOtefuw0t/hrrZ+G5wtvChwFoRf
         +B6tHGOhzl5YZmfqdDoUiqPgIw//7WrZWrXUHfn5CU1ASpIDO7LJGEahybnAfW5Xua3h
         I95pVH5ie3+UnI90lbCQwzFusXPsEHnn3tcmFYj753xWd3BSu+a498hgz0zeVADrcxIX
         1qK7QwZS37zu8UWVXuZ/XfvS22ibCvHlHGecvY/Q/1NjKb78CbPQmi5KiJN9eu7lMeg1
         31MQ==
X-Gm-Message-State: APjAAAXlPe7qC4JWTF2/0wmtHV9/JgWb6jHeXz8Ox7oNJaoPZkG//S0M
        SnAqoG3OQ1/Qecu+seXLygxrH0vTpbY=
X-Google-Smtp-Source: APXvYqzbcAnjqEm/3xGSfv2zxsGBLBSS8RewFUzqeARnioRcfRs/c7/H37bXFtJJ9Qa32wmpdL/dmw==
X-Received: by 2002:a17:90a:c503:: with SMTP id k3mr33767600pjt.46.1560352214256;
        Wed, 12 Jun 2019 08:10:14 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f17sm17599012pgv.16.2019.06.12.08.10.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 08:10:14 -0700 (PDT)
Date:   Wed, 12 Jun 2019 08:10:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Transmit VLAN with AF_PACKET
Message-ID: <20190612081007.32dcb7ec@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sending VLAN packets through AF_PACKET over Hyper-V netvsc driver doesn't work now.
The question is what is best option for fixing it?

AF_PACKET handles VLAN stripping on receive, but there currently is no mechanism
for VLAN offload on transmit. Instead an application may form a raw packet with
a VLAN header and inject it into the kernel. This works fine for most drivers.

The problem is that in order to send a VLAN packet through Hyper-V, the VLAN
tag must be stripped and placed in the NDIS meta data. If the VLAN header is
inline in the packet it gets dropped by the vswitch rules as an invalid packet.

There a several options for fixing this and would like some consensus.

Option #1: Add code in netvsc transmit to look at packet and do a
VLAN pop if necessary before doing the normal VLAN tag handling on
transmit.

Option #2: Do a generic solution in AF_PACKET so that if application
sends a packet with VLAN header, it gets popped and inserted into skb.

Option #3: Add new tpacket header on transmit to match the Rx VLAN
tag strip on receive.
