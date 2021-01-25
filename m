Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6F9302C66
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732206AbhAYUTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:19:47 -0500
Received: from root.slava.cc ([168.119.137.110]:50199 "EHLO root.slava.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732262AbhAYUTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 15:19:11 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2021 15:19:07 EST
To:     xiyou.wangcong@gmail.com, willemb@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=slava.cc; s=reg;
        t=1611605416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=i5B2EWuCy6A1MEWWXQPko8yQGXPjkPPn38hEpcNqnXk=;
        b=sI6EVTEk5j1AGgbowKbZW+tr0A2xkxNAUe3LVz/NnmM/nS59vMzoebLEJ+wSkF2cgGsWQU
        9fFTK+R1daiCKh9LLAVjrwQ3HIwE/hWggovA8JaKY/c8HXDeOizxwI9ZO8l5675ROAs/gz
        nwwqiwIfiw9ITPom00Ze75SOL9xWuTU=
From:   Slava Bacherikov <mail@slava.cc>
Subject: BUG: Incorrect MTU on GRE device if remote is unspecified
Cc:     open list <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        kuba@kernel.org
Message-ID: <e2dde066-44b2-6bb3-a359-6c99b0a812ea@slava.cc>
Date:   Mon, 25 Jan 2021 22:10:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, I'd like to report a regression. Currently, if you create GRE
interface on the latest stable or LTS kernel (5.4 branch) with
unspecified remote destination it's MTU will be adjusted for header size
twice. For example:

$ ip link add name test type gre local 127.0.0.32
$ ip link show test | grep mtu
27: test@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group
default qlen 1000

or with FOU

$ ip link add name test2   type gre local 127.0.0.32 encap fou
encap-sport auto encap-dport 6666
$ ip link show test2 | grep mtu
28: test2@NONE: <NOARP> mtu 1436 qdisc noop state DOWN mode DEFAULT
group default qlen 1000

The same happens with GUE too (MTU is 1428 instead of 1464).
As you can see that MTU in first case is 1452 (1500 - 24 - 24) and with
FOU it's 1436 (1500 - 32 - 32), GUE 1428 (1500 - 36 - 36). If remote
address is specified MTU is correct.

This regression caused by fdafed459998e2be0e877e6189b24cb7a0183224 commit.
