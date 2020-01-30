Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E2614DB28
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 14:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgA3NCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 08:02:18 -0500
Received: from mail-yw1-f43.google.com ([209.85.161.43]:43590 "EHLO
        mail-yw1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgA3NCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 08:02:18 -0500
Received: by mail-yw1-f43.google.com with SMTP id f204so881384ywc.10
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 05:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Pa/ccRm4RbffTLTyLYWqpDsnkj37/rCOT9I/Na1RIiw=;
        b=EV2wFM9jCDNrzyxRE+MLC/O5X9hf34kHlPv+KQo67pVC0TPGbaQ67VSV5OGwpWnbNd
         lL8TTxMsd5vx1mXcEJvAaYJ8uO1rkPz9bqKerGy+SjLp9TXUb0TQ37+vtiMoVGE/HSE/
         FK2bYrMRE3kRuclQU17cwlpytDblOPtHoisjeHRq9T75DQL2ao3A4T9XdZkToHg0qS2s
         JwtYA1rqxTBED6CCTs5KbT18gXBEnRWugQLNC2RCKVwmRiUaU0FZF29+pUiutsMcrlG2
         0IhFWnw9MqlnNvUpIp86O+paBOgNzV1WJfRj/dDV+g5uVSImCbe+1MVloJBXAeq1j2Vf
         2rFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Pa/ccRm4RbffTLTyLYWqpDsnkj37/rCOT9I/Na1RIiw=;
        b=D7gzgEey9VZ+v+kGsKxa1psQ/fd6bl9LkQh0XPPnJ8ieiQrvLHr5vFqF8xsa8dPM3z
         rk3li/xANDqViuTGvF6JGl+5T+hfc/cjVoNWqPJuqD3oNodlRfMnpta+nHMTpha47DlH
         gEFLP5qEXrqM4njZ2mPGFWAHMl9C2Akcc+VBcXvn3TKenqIX6Daq4IfoIjHvPG/tYW4X
         rH6UaU4WiQwRBtSVQyIngAVWfgsn5LxTJZDOKUYeqdDTgz1QJGW1ghkT5Prd0wk29IyC
         WRhUL+clT/Pc8yX+avpla+ErRtzCqBvZS8L+nDv0Zmc2wzR7xH4N3loH/bkuLNoPi/zg
         Z9yg==
X-Gm-Message-State: APjAAAXVun+kTH3XO5Lz2WatLrftbrw5T5Pk0L8J8oe9VwYcqBO/ni6o
        fC7e5CQO/T2XQdqXkM6jjm5G104xU8cVmfIgS/LS5YxvmXw=
X-Google-Smtp-Source: APXvYqzsH/926Ud7gueNiqkXD6RTSeTZEuOqpu7qLeY/xfKSmp8wQJs6H6USgUFWVHWZo0hdPlsK1m2AvZqjiCtAh3Y=
X-Received: by 2002:a81:3212:: with SMTP id y18mr3237937ywy.247.1580389336443;
 Thu, 30 Jan 2020 05:02:16 -0800 (PST)
MIME-Version: 1.0
From:   Martin T <m4rtntns@gmail.com>
Date:   Thu, 30 Jan 2020 15:02:02 +0200
Message-ID: <CAJx5YvHH9CoC8ZDz+MwG8RFr3eg2OtDvmU-EaqG76CiAz+W+5Q@mail.gmail.com>
Subject: Why is NIC driver queue depth driver dependent when it allocates
 system memory?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

when I read the source code of for example tg3 driver or e1000e
driver, then looks like the driver queue is allocated from system
memory. For example, in e1000_ethtool.c kcalloc() is called to
allocate GFP_KERNEL memory.

If system memory is allocated, then why are there driver-dependent
limits? For example, in my workstation the maximum RX/TX queue for the
NIC using tg3 driver is 511 while maximum RX/TX queue for the NIC
using e1000e driver is 4096:

# Broadcom Limited NetXtreme BCM5722 Gigabit Ethernet; tg3 driver
# ethtool -g eth1
Ring parameters for eth1:
Pre-set maximums:
RX:             511
RX Mini:        0
RX Jumbo:       0
TX:             511
Current hardware settings:
RX:             200
RX Mini:        0
RX Jumbo:       0
TX:             511

# Intel Corporation Ethernet Connection (2) I219-LM; e1000e driver
# ethtool -g eth0
Ring parameters for eth0:
Pre-set maximums:
RX:             4096
RX Mini:        0
RX Jumbo:       0
TX:             4096
Current hardware settings:
RX:             256
RX Mini:        0
RX Jumbo:       0
TX:             256

#


thanks,
Martin
