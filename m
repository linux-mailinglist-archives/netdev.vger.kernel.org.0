Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BBB3281A8
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbhCAPBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbhCAPBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:01:45 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00F3C061756
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 07:01:05 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 105so16735549otd.3
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 07:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=lABWButIZH2daj0A8oyuwcLJlf8u4Lya7J0JYdVPpd4=;
        b=LJvt70BQTzqL8IWMpD5ItXQcWkKO4MlhGHgYyUlcI8yVvuN/6oMpR6AiO6RcW+YpFC
         CPOV2oqLjEj/V1Ye3FK5njFjly1l+wiASGy5j2YOKVdmH5oGNSbvUwSd+XhM9U00dqhk
         OpKjhd+BBKithDN8dT8NiQTt9NyHnvsfkCxCA1L9PKky484JULBDGsqT+ach1GX65Xqw
         f9T1qRJJOesYFbhlGFEj/N050wkni0e/+76y+TdDfEjgavheOTbUxsunw7gHdZFmtVip
         ky4JKTKleVvwGXFFbmEFr5M4tYm3UVVSMUjmWYmDjpfiyIri9CNPHZUfWaR7I5Vc4eD2
         jDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lABWButIZH2daj0A8oyuwcLJlf8u4Lya7J0JYdVPpd4=;
        b=PFo0cvsH8bX6OMVLh9u7tvBSx24R9VZiWnnIxtRaqjB45Fu7BBMXPQvqGjJqzHHQNU
         GHeJgTyar9HkYP5HKHErw+728gkI0tMdzJnipSL0Rm1aXOXr3HZ/L7b84fn1P/okJsSj
         qvUbSYSSEc3BlAvVCubE+t5fyT3j7X8nwhc6DwEH1u9rjlRzbsWabbvv14/SCQFGjJfL
         UXH8aQhsKadfsT14CvDyGd4M8qTJiRJU4lOUzwkormQwhk7BvGNJWnDsvzpnzD/fbTYZ
         a8dy7UNHIYHuk81nDvw89Q/CyhUHgHmL31/Z/4PJkoj9ZV+Lv9ld3drdzdmTdbWTNcmY
         tFMw==
X-Gm-Message-State: AOAM5328ooseUE9l4elYNL9CO8yHBEH8T4gCkmrBYzTzVewq78PPq+bq
        xBA6wjvPZYfjRVB3HBtKG1EpICCnLM14mb9SdM5dbdPRWDwvUQ==
X-Google-Smtp-Source: ABdhPJzuQBH+25CxNjAMADj9POUjOmORureUbMh310cBVh2OE3qLFpw+a1vbLFK8edTe3TEKpvkF7U+Es+IxYxA6ie8=
X-Received: by 2002:a9d:3ef5:: with SMTP id b108mr3221877otc.89.1614610864705;
 Mon, 01 Mar 2021 07:01:04 -0800 (PST)
MIME-Version: 1.0
From:   Tom Cook <tom.k.cook@gmail.com>
Date:   Mon, 1 Mar 2021 15:00:53 +0000
Message-ID: <CAFSh4UzYXp7OaNcZOWQfyxznQfcF+Ng0scboX9-kxhrcpLKd7w@mail.gmail.com>
Subject: MACSEC configuration - is CONFIG_MACSEC enough?
To:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm trying to use MACSEC on an arm64 embedded platform; I'm trying to
create an encrypted channel between two of them rather than doing
switch port access etc.  The vendor's BSP only provides a 4.9 kernel
so that's what I'm using.  I've added CONFIG_MACSEC=y to the kernel
config.  This then forces CONFIG_CRYPTO_GCM=y and CONFIG_CRYPTO_AES=y.

I've tried both manual configuration of MACSEC interfaces and also
using wpa_supplicant to do MKA negotiation.  I then add IP addresses
to the MACSEC interfaces in the 192.168.149.0/24 subnet.  In both
cases, the result is that the macsec0 interface has flags
BROADCAST,MULTICAST,UP,LOWER_UP but is in the UNKNOWN state.
Attempting to ping from one to the other results in encrypted ARP
frames being transmitted but then discarded at the receiver end.
tcpdump shows the frames arriving at the receiver and `ip -s macsec
show` shows these frames being added to the InPktsNotValid counter.

AFAICT from macsec.c, InPktsNotValid means either that the decryption
failed or that memory allocation for the decryption failed.

Is there some other bit of kernel config I need to do to get the
decryption to work correctly?

The SOC is a cavium cn8030.  This part is equipped with a crypto
accelerator but support for it is not compiled into the kernel.

Thanks for any help,
Tom Cook
