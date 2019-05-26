Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC12ABCE
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 21:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfEZTOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 15:14:36 -0400
Received: from hermes.domdv.de ([193.102.202.1]:4076 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfEZTOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 May 2019 15:14:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:To:From:
        Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pofMlofFZUBCIdS1joXB/VUjNMTGv8LPattqFLDcsOQ=; b=RTKtMsfhQE2VAjjPGFTk2hEQgv
        QLWeQWd3rXPlZXvUHvLtZx1ZSNmyKwe1nHnIZsK3lwx+VNT2Ui3YPlofzVJvibUoQ0w46DePUwQRK
        BwseNLTk7lGSq+/mpPo7/L1pKYKCC5fFgtT3dlfapUhfYsVLY2kxsa3C7vDpsxGNSWZo=;
Received: from [fd06:8443:81a1:74b0::212] (port=4736 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hUybM-0003fJ-FE; Sun, 26 May 2019 21:14:36 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hUyai-0006Sn-SC; Sun, 26 May 2019 21:13:56 +0200
Message-ID: <c93c79da4ce6704857324d30f42e82587f522a67.camel@domdv.de>
Subject: bpf program loader doesn't honor CAP_NET_ADMIN
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Date:   Sun, 26 May 2019 21:14:11 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quite simple "program":

start as root
configure rlimit_memlock
drop root but keep CAP_NET_ADMIN and CAP_NET_RAW
create network interface
configure network interface
create CLSACT qdisc for interface
reconfigure eBPF program for interface
call bpf(BPF_PROGLOAD, ...) with program type BPF_PROG_TYPE_SCHED_CLS

Result: EPERM

That bpf() does honor CAP_SYS_ADMIN doesn't help as this is too broad
for network related actions and may pose a security problem.

Privileged network related bpf program load should honour CAP_NET_ADMIN
in addition to CAP_SYS_ADMIN.

