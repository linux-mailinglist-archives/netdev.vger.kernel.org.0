Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6E368C66A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 20:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjBFTGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 14:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBFTGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 14:06:45 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6D722DC1
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 11:06:43 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id hx15so37003503ejc.11
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 11:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmd.nu; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vZeRBuwZH+IvkBbfAAmdbf0CtMbQQYHRqOEg61lJ2BA=;
        b=Gp11PJY1jbbc4a9WKvm+J+jdm9hnpPufj8TKne+cHuS0p1XgT8A4o50Y51PFF286mw
         aO0rynd95hKG23Uckzyb3MgOVvQr0ZepyUZ/kyYbvorSVeCBe3atl3hmXMu2ltBjIkuq
         Rkq7PrqaeU2r2Ti0FILshYz/apAISUQU1zGr0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vZeRBuwZH+IvkBbfAAmdbf0CtMbQQYHRqOEg61lJ2BA=;
        b=Y/0hwHKPn4/0hUQyCbOBjtVYk6gp3mM0HtWFHzV2YEgRBdT1so91pTgyE64SUqWJ5g
         VNV/W92OhlpGoDI1rZh3cuglL+PJWOFTlZpL7X06mwEQDiPI8woQts2fNyL2HrKFveZT
         kFjX9HuWRQPF7B5c7u1Bv2rcWLn+A3e9e6YwdF26nOBRqm0SKiXCMS9+w8aj95CRqyDq
         s7jrtzPzaNr8B6DQte6ciRGq7fVyccvDx+oXBQa+xhvHC0TxB6Buh/VS6a7PTfw/ImJL
         2GvqXcx3MUNZYQmK841Vo6hlrphjSkQ5ErkTF5/4Zz0DZPxzUm4pLiR+ILWg+UVSsJ9r
         EanA==
X-Gm-Message-State: AO0yUKX/aj8GI87weJgyu0W3+yVZdUiLBQotAixFQKCY9VgYLgZlYCx+
        eI2wsrAsvH25VIWGyGA3guF5jcacx86BqT+LmOafgA==
X-Google-Smtp-Source: AK7set9ozao+qudCjNcIl/iaMIzn0SGD5MTbqTtSI5urVg6NpNq+31l6WQ5TdwFfXfzJ7uXaMfgpudMmf0xk2gvB/Yo=
X-Received: by 2002:a17:907:775a:b0:878:5995:97ed with SMTP id
 kx26-20020a170907775a00b00878599597edmr123023ejc.277.1675710402519; Mon, 06
 Feb 2023 11:06:42 -0800 (PST)
MIME-Version: 1.0
From:   Christian Svensson <christian@cmd.nu>
Date:   Mon, 6 Feb 2023 20:06:31 +0100
Message-ID: <CADiuDATAsP7cvxmV9d8=P0j=75XRxvX3jm32d6PQ_Wqv8NR_6Q@mail.gmail.com>
Subject: ethtool's eeprom_parse fails to determine plug type due to short read
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Viktor Ekmark <viktor@ekmark.se>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am currently running a system with an Intel E810 ("ice") card as
well as 2x QSFP28 transceivers made by ColorChip.
The behavior I am observing for these modules is that they return
zeroed data unless the read length is greater than 8.

$ sudo ethtool -m ens1f1 hex on length 8
Offset          Values
------          ------
0x0000:         00 00 00 00 00 00 00 00
$ sudo ethtool -m ens1f1 hex on length 9
Offset          Values
------          ------
0x0000:         11 07 02 00 00 00 00 00 00

eeprom_parse uses a 1-byte read to determine the type of module. This
obviously fails in this case and the function resorts to printing an
hex dump - which ironically contains the correct EEPROM data.

I can see three options to handle this case:
1) Continue using 1-byte read, let ethtool be broken for these types
of modules (the current state)
2) Switch to using e.g. a 16 byte read. Might break other modules?
3) Use a 1-byte read, and if it returns zero as the type byte, retry
with e.g. a 16 byte read to see if that works better.

Thoughts?

Regards,
