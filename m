Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039A92CE8E8
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 08:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgLDHyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 02:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbgLDHyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 02:54:01 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C809C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 23:53:21 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id f11so5239268oij.6
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 23:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=opFmVYSdRzVMzc8euCq3gxQLlBBxHquTLQWB9SfXpsY=;
        b=ghRUEdNpduPnDDfgJ7Y77lNyZhuWxooWlVtN+4TuDpT3j7yXQOJkBpoS0q8XIN3CMn
         sNIGGNGBqTYixhE3/lS7zQot/SvWRRHnW87Q1FRoATDvJehelGYcqWb9X+z/PAB09MGl
         J3S+Ds3DtrEztuvjeowuR79CYPzDMr9LSMiKzepW1/Iu9sf2ougt3XddvIp7Ip+YFe3x
         290/7cye4H+8qR/UWJ3z8YGhqD28KtOFXakE7vbmsQ75ywxzBDA6xh1zW02CVqtd3xjY
         THDLJaNE2SbYlD6gJOLcpKrMuetjfZyUjA0PrqFxl/bFeF8cRWoyc9ZBYY77+e+VtxWp
         UaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=opFmVYSdRzVMzc8euCq3gxQLlBBxHquTLQWB9SfXpsY=;
        b=bJ7s7E2BbN9j4G7u9h6dYx75xHZHZwyGqYS7g7s+24M/Y7VM/oQzx8CFScer9uw+ER
         MiP1rPXvfn4QTck41HnBwq00MIY0fnIABLzGmfNZOMYJ0tPk1mutMnfoWQtB7eBdhl6y
         WsTX0AF/qMcgmINewKPcOaZ0HcSmauQmHLrOG/fMs7g82q+ByOEpwsybwYuFA+WmZov3
         MPsR0dC4ekpyn48k0ySSc0XbbmvQtGckXrTdo2OJ+KZXkuO7tCTmfIrcXR7OPAvYL6X2
         i6p/I8tTMgZhAMUIGuTAwSJ3QD0oCGUA+brXHZB8ORh6UffrYH1Cy+9+9ztSeE/T7hKs
         HKaQ==
X-Gm-Message-State: AOAM5310dk5vQartnfW02bLsAbDCvRIQ8xHIHOkkDA5kTBrPyIckNfpD
        zNF5PeHzTanPbHZS/ICcfzoIxezIMx65r1MKx1X5k4v+
X-Google-Smtp-Source: ABdhPJy+WQzNzdMTH6XY5EThvK3B0b34cQrQd3ZJSKxzVnuFP12/fv72qqUWD3akwi+10pB7PkcIx7R3fOz7Yxou4m0=
X-Received: by 2002:a05:6808:914:: with SMTP id w20mr2309505oih.70.1607068400379;
 Thu, 03 Dec 2020 23:53:20 -0800 (PST)
MIME-Version: 1.0
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Fri, 4 Dec 2020 08:53:09 +0100
Message-ID: <CAKfDRXg-wt1mh+W8z6rbuqrdm81Lr132AmnECUqy-1Up4E=7RQ@mail.gmail.com>
Subject: QMI QMAP interface stuck after power-cycling module
To:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I am using QMI together with QMAP when configuring and connecting my
LTE/5G modules. This all works well, but I have noticed something
strange when modules are disconnected from the host. Most disconnects
goes fine and everything related to module is removed, but sometimes
it happens that the network interface is stuck.

Even though the "disconnected" messages appear in dmesg, etc., I can
still see the network interfaces in the output from "ifconfig" or "ip
link". When I look in /sys/class/net, I can see that there either are
broken symlinks or regular files belonging to the interface that is
stuck. Running "ip link del" just gives an error, the same goes when I
try to clean up /sys/class/net manually.

There are no error messages printed in for example dmesg when the
problem occurs, and the modem works fine after it connects to my host
again (albeit with different network interface names). I have not been
able to reliably reproduce the issue, but I have so far only seen it
on "fast" (x86-based) devices. On the "slow" devices that I have
tested (like mt7621), I have not been able to trigger the problem. I
do not see the issue at all when using QMI without QMAP.

I tried to look at the code in qmi_wwan, but couldn't find anything
wrong. with the QMAP clean-up code. Does anyone know what might be
wrong or where to start or keep looking?

Thanks in advance for any help,
Kristian
