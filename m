Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794062F985C
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 04:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbhARDtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 22:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728799AbhARDtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 22:49:03 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FDCC061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 19:48:23 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id v19so3798716ooj.7
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 19:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bbjv2rwFeRzVeFSJbNccCOB3REl59JtHTHaK5PWxV3g=;
        b=XoHJ9+/AMaUGHFUurBSqkhnd/NRUPyuivWSVPu5N8akE3Jrw1PP/uC8X9UKYY+Nlu1
         dhEExSaq49HZ8af3czHlCc0vgdNLJ0r8DETuyZMtjU7bUHXzWhtDg6IC9y1L8hKP/j10
         /H7QNCpIMEMrinKsL+ano5sZm8B6O5K3SK+/4FodEpXjdpjMCFFo8WEtWpC5Mb6Ki/dm
         QBE5TI6JAOEmX3QFUdPpgw5KzAl05MzEEL8oCA0M10h5LpnJ/eqPlB9Sh/p09J2PQWor
         mCM/kKdAdBRnTkKYDw4tBDdVjN0/4Y+a3QFfXxaDI7yvgvx407VaOURtMNgkO1NYJCuq
         utnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bbjv2rwFeRzVeFSJbNccCOB3REl59JtHTHaK5PWxV3g=;
        b=jqN7rO8vPZKRIUUsXGzH6tIwoMck1jqjQ6QpYuTnDnXKC7ykyucQrhJ5ZHkKW7WmIC
         VtHSUu/8WA4uWLETG7dljn7Vwc3rsRPYsicy6PAdEj7hGw2klmqMUZh0DD6q9Xfjygcf
         JXCfH+BFymJ6LxTcRp3pgEugkH9VTp5rmHrq0t8OI1fMJN2dxrad33suoCJ8ND1Cj+5G
         szIAgYKw9zoRKqsG1iKjDVYaB68CvjuXPhaZ/I0mMNqV9lfcTnlmyiABI2zlQN8jS2xQ
         h5VFBbRhfAgalxZbDb5PVjzHECZz7stoHQlWXBVy+iEusN8grvAR+0t97pGIW/zN7O7K
         I4kQ==
X-Gm-Message-State: AOAM532/62sD6WnbZy9OCEySwG7/mP6H1ezujarZHrwYRpmon3k+AwML
        yVWan2v9WjHXW+jR+qxAvsM=
X-Google-Smtp-Source: ABdhPJwZGb16LHp5sBpw+4MiZKXzMBAi1JDWWqMqICaDJ3r1Cyhnwey7fro23ub4LyOO5lcLVMUPVw==
X-Received: by 2002:a4a:81d2:: with SMTP id s18mr15773873oog.76.1610941702561;
        Sun, 17 Jan 2021 19:48:22 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.181])
        by smtp.googlemail.com with ESMTPSA id q127sm3165752oia.18.2021.01.17.19.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 19:48:21 -0800 (PST)
Subject: Re: [PATCH iproute2] iplink: work around rtattr length limits for
 IFLA_VFINFO_LIST
To:     Jakub Kicinski <kuba@kernel.org>, Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
References: <20210115225950.18762-1-edwin.peer@broadcom.com>
 <20210115155325.7811b052@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210116211223.xhurmrb2tqlffr7z@lion.mk-sys.cz>
 <20210116172119.2c68d4c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <807bb557-6e0c-1567-026c-13becbaff9c2@gmail.com>
Date:   Sun, 17 Jan 2021 20:48:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210116172119.2c68d4c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/21 6:21 PM, Jakub Kicinski wrote:
> 
> I wonder. There is something inherently risky about making
> a precedent for user space depending on invalid kernel output.
> 
> _If_ we want to fix the kernel, IMO we should only fix the kernel.
> 

IMHO this is a kernel bug that should be fixed. An easy fix to check the
overflow in nla_nest_end and return an error. Sadly, nla_nest_end return
code is ignored and backporting any change to fix that will be
nightmare. A warning will identify places that need to be fixed.

We can at least catch and fix this overflow which is by far the primary
known victim of the rollover.
