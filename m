Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDA8222D13
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgGPUiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgGPUiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:38:17 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C77C061755;
        Thu, 16 Jul 2020 13:38:17 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id d17so9859514ljl.3;
        Thu, 16 Jul 2020 13:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=2O7bQWDLwUQDhW0OWAcbDHupVIWe6xHnIDUrKXN+BPE=;
        b=tayLBiK/WNaM9ea4BqBDSKhbMdqpMJ8yMhQ2ZgaKzKGSoUcoHHS4cfokqB9mxIVpxi
         sp+xoUxTXku7dRJg5p2wfpRHztxxiWjPfV+mEFuD258pgivHSOyEqR5QCGQWmkIJsi9H
         C8W6LhHnoSu4O9RU9paS/EB1PkLocmxKif1LymCGQCmBPhQQHKyFBIRls/D2rvu1P/uv
         gMq+6FNPlF4K2zBL0T43L9WSsLD+rcWlY/9gnn9klm29IzYFmpWTxREb1PTTNI2ss/nm
         8n6+Fh1GbggE+3yiVKbaZibdtHz7xAtbrHVI1uu1NJJ8+ItK6JtDzeTi2Qkig6AnwWex
         +6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=2O7bQWDLwUQDhW0OWAcbDHupVIWe6xHnIDUrKXN+BPE=;
        b=Y13yuLDbf5psSAq1oD93Fhk22Rkd9c2RHm6BfKeiQdWDtFG/7XL0sXQqUxCwvwgdky
         rsDXdNrX/YqLqZ8a6bH/GAayoZ302KhZdZD7ue95vw0rIpkvzACAf3O+SIdIH8FijiFm
         yuPLHMIiJ6DcMiW5KenPC2r5tt8DoXOfKfLNjcwLGMjA2FHVYDTv5kfqmAj10ah9FJNV
         LGStiRo8vBptDrpfc6dWsjfveleE+ya0GAAB3u2H/KUp1zwpHbkoP5dFf23lRDe4/bUq
         Wb/lS8wQzydV2dazzfCYi7AsdtsQlvmKmA8DK6bXgvbrPSdtvebAjdKHN6y8XAJN+A4Y
         AbrA==
X-Gm-Message-State: AOAM532bpqdP8HRp3rekd2qBtth3MLBrjBr8hkVx4L55h/a3oYB5Zil8
        sB3LO/ps9Z3Y140GlHt3GrI=
X-Google-Smtp-Source: ABdhPJxOSwAJQ63NMiBWyfyxbqKJ3ey6voIYtjuqT0rVfl/afoSGNY0ZkTRz5Zs43FNSIK3hlG6xRA==
X-Received: by 2002:a2e:85ce:: with SMTP id h14mr2692804ljj.356.1594931895810;
        Thu, 16 Jul 2020 13:38:15 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id n3sm1244807ljc.114.2020.07.16.13.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:38:15 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 net] net: fec: fix hardware time stamping by external
 devices
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200714162802.11926-1-sorganov@gmail.com>
        <20200716112432.127b9d99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 16 Jul 2020 23:38:13 +0300
In-Reply-To: <20200716112432.127b9d99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Thu, 16 Jul 2020 11:24:32 -0700")
Message-ID: <87a6zz9owa.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 14 Jul 2020 19:28:02 +0300 Sergey Organov wrote:
>> Fix support for external PTP-aware devices such as DSA or PTP PHY:
>>
>> Make sure we never time stamp tx packets when hardware time stamping
>> is disabled.
>>
>> Check for PTP PHY being in use and then pass ioctls related to time
>> stamping of Ethernet packets to the PTP PHY rather than handle them
>> ourselves. In addition, disable our own hardware time stamping in this
>> case.
>>
>> Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware
>> clock")
>> Signed-off-by: Sergey Organov <sorganov@gmail.com>
>> Acked-by: Richard Cochran <richardcochran@gmail.com>
>> Acked-by: Vladimir Oltean <olteanv@gmail.com>
>> ---
>>
>> v3:
>>   - Fixed SHA1 length of Fixes: tag
>>   - Added Acked-by: tags
>>
>> v2:
>>   - Extracted from larger patch series
>>   - Description/comments updated according to discussions
>>   - Added Fixes: tag
>
> FWIW in the networking subsystem we like the changelog to be part of the
> commit.

Thanks, Jakub, I took a notice for myself!

>
> Applied, and added to the stable queue, thanks!

Thanks, and I've also got a no-brainer patch that lets this bug fix
compile as-is with older kernels, where there were no phy_has_hwtstamp()
function. Dunno how to properly handle this. Here is the patch (on
top of v4.9.146), just in case:

--- >8 ---

commit eee1f92bbc83ad59c83935a21f635e088cf7aa02
Author: Sergey Organov <sorganov@gmail.com>
Date:   Tue Jun 30 17:12:16 2020 +0300

    phy: add phy_has_hwtstamp() for compatibility with newer kernels

    Signed-off-by: Sergey Organov <sorganov@gmail.com>

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 867110c9d707..aa01ed4e8e1f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -595,6 +595,15 @@ struct phy_driver {
 #define PHY_ANY_ID "MATCH ANY PHY"
 #define PHY_ANY_UID 0xffffffff
 
+/**
+ * phy_has_hwtstamp - Tests whether a PHY supports time stamp configuration.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_hwtstamp(struct phy_device *phydev)
+{
+       return phydev && phydev->drv && phydev->drv->hwtstamp;
+}
+
 /* A Structure for boards to register fixups with the PHY Lib */
 struct phy_fixup {
        struct list_head list;


-- Sergey
