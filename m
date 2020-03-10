Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7471809EA
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgCJVHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:07:36 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:41371 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCJVHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 17:07:36 -0400
Received: by mail-pl1-f181.google.com with SMTP id t14so11547plr.8
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 14:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=59B0oTF6VX/A3nMabRxoAwwidqs9Qvg3mH256/t678Y=;
        b=YKe+RcI3KMxzrIaHbkAcl8c2dAX2bxwTkiRNFiM7eEPJ0DU+J3cRK9aY+bP3QwFICW
         hImdUP0bznxSDAfImfpUkKmOLTjAx7VI5S9P6oYxYg6JEvmZi99ZhrTEK1ZjTFJiCgV6
         I2wSak4+ZIsTWoKFxUKiyX0AxCggEU+mnwRl8Q3Ms1mIX8RbfMucFHz0iaDLhbh075Ug
         42bzAQg9dJTs63fLdg1BGZL/X0ksyvh4N+wfaFNtrXvpUMY2nSgGjcWxOBg2V0S8U7f8
         iaoHUIwba0fA7dzYfSeLw7ArHQen6q2qDbuAGZBGfL9RzxigWpqGknjs+5CseptWNYhN
         xStw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=59B0oTF6VX/A3nMabRxoAwwidqs9Qvg3mH256/t678Y=;
        b=D1BV5IXaGAic0tkfHB2ESxjLsXPeV56P60BQ/NRwKgG8XRcafiJO/wuI6ZRxCrdLKE
         2HYTh8/reMeCgvqP6nzkEXBWzPJh5oP22JKs5+3SqDpGabbBmoe8oX9N1F1waTzwY3/z
         ixt2MDSqAgoZcmKW8Xagp7YqTVxuYiNBtqjjhFU1e4XJNTYsSq5G9oAO920oIET1B6x2
         66QwyQc9C3NNMtfpFimqJAvBo6KMBTu02WwrFo70B6KR7rP2jc4XZJZCGUYbUP2pHn23
         R1I/t+1tOqYexxisvKEg0M/xU46xTICsbbTB3QVWyua55ZtYtdx8oj+S2IzdNTvUr66T
         KL6g==
X-Gm-Message-State: ANhLgQ1rA2VBk+Gf13i/7MjJmk1rM0hbSANj+rKXGXUfXlpCm7HEGK1j
        1bSQdtmWvS5MIPMe0mvF3XbZc/sTfsI=
X-Google-Smtp-Source: ADFU+vuve0I+YcV7fpQm7kz1b/Itso/tm8xeolwCdP2zc6rghacHh+qYi/FCyKwUh4CwIws/nMFLuA==
X-Received: by 2002:a17:902:ab98:: with SMTP id f24mr21843762plr.338.1583874455234;
        Tue, 10 Mar 2020 14:07:35 -0700 (PDT)
Received: from jprestwo-test.jf.intel.com (jfdmzpr04-ext.jf.intel.com. [134.134.137.73])
        by smtp.googlemail.com with ESMTPSA id dw19sm3127332pjb.16.2020.03.10.14.07.34
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Mar 2020 14:07:34 -0700 (PDT)
Message-ID: <ed7b025e63df2913f8605cbd492d86dacd35e1f0.camel@gmail.com>
Subject: Solving RTNL race conditions
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Date:   Tue, 10 Mar 2020 14:02:56 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am adding support for MAC randomization to our wireless daemon (IWD)
and noticed the potential for race conditions with doing so using
RTNL. 

In order to change the MAC on an interface you must first power down,
change the MAC, then power up. These operations are done asynchronously
in IWD since it is completely event driven. During this procedure RTNL
emits a NEWLINK event. IWD already handles this event for interface
management, but in the case of changing the MAC IWD would ignore this
event since we initiated the power down and will power the adapter back
up later.

The issue I see is that something external could come along and power
down/up the adapter during the middle of this exchange. IWD has no way
of knowing where the NEWLINK event came from. Was it because of us? or
was it external?

I am not intimately familiar with RTNL, but several NL80211 commands
provide a cookie which is included in the success response and also
included in any future events relating to the original command. This
allows the daemon to check that the cookies match, and knowing that the
event was a result of something it did, vs something external. Is
something like this feasible to do in RTNL? 

As sort of a back story: we tried going the linux-wireless route and
adding a flag to allow changing the MAC without a power cycle but
ultimately that was not accepted. IIRC the issue here was with the
NL80211 flag which told userspace if the adapter supported this
feature. As a userspace application we needed some way of knowing if
the adapter supported this feature, but the maintainer did not want it
in NL80211.

Thanks,
James

