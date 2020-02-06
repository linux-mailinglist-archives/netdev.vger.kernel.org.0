Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9BE154E69
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 22:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgBFVzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 16:55:23 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55175 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgBFVzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 16:55:23 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 76877a17;
        Thu, 6 Feb 2020 21:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=iEyYXoQeVJvL9VxBSqdINnENhik=; b=12M286
        QcFw7FfPyXUco6JL08r7fRheSId3gtQL4kmvo3WK+hCB+kd0toeYc/mghSa19jwq
        tIPpgmpmkSjxghjAKTrRHPzbF+vhLq2CNgcx4F2UPCLtwbZdqHcjZ/a3zrOnHBBv
        KFzIu/HCMm72R2I2G7vvFXkOg0JF5+d3YDoGgl7E0i8nbREKFyvF/SAFeNA/sygr
        aPZOqTaftwxalanM8Iv2JBkwwOrFMaVWMYb6VZg7RMHpfYCkBUggltYHBSDziYSq
        J7Rpy1elZ2M1mlN72uIQlxvU33NrlwdeA25FIGa0Qx7pDoVLwGeG25eY71yw2/7W
        I+ro8sh+UWoIEh7w==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3e4ade7e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 6 Feb 2020 21:54:14 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id c16so6252794oic.3;
        Thu, 06 Feb 2020 13:55:20 -0800 (PST)
X-Gm-Message-State: APjAAAW2gXE9oxCaffzDOE4I9xsWxeiFYoXn3SDmBq4AoBTmWwEvMTuZ
        A6ARu0WEO07l9dscrwKZRRvrKazNBVA3cFHR+CE=
X-Google-Smtp-Source: APXvYqyEsdNrxjDdXuCYJDqUYruajj4xtoIZ5dk0Shwq1ewne2L7eFL197kHYxueoLyjEE5plCZkXk6x5VTXY0hNAgQ=
X-Received: by 2002:aca:c383:: with SMTP id t125mr33887oif.122.1581026120166;
 Thu, 06 Feb 2020 13:55:20 -0800 (PST)
MIME-Version: 1.0
References: <1580841629-7102-1-git-send-email-cai@lca.pw> <20200206163844.GA432041@zx2c4.com>
 <453212cf-8987-9f05-ceae-42a4fc3b0876@gmail.com> <CAHmME9pGhQoY8MjR8uvEZpF66Y_DvReAjKBx8L4SRiqbL_9itw@mail.gmail.com>
 <495f79f5-ae27-478a-2a1d-6d3fba2d4334@gmail.com> <20200206184340.GA494766@zx2c4.com>
In-Reply-To: <20200206184340.GA494766@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 6 Feb 2020 22:55:08 +0100
X-Gmail-Original-Message-ID: <CAHmME9oaPDNwXOAZSLRHQLawhRBPfgH4OewNBZH9Z_uL6BDDhA@mail.gmail.com>
Message-ID: <CAHmME9oaPDNwXOAZSLRHQLawhRBPfgH4OewNBZH9Z_uL6BDDhA@mail.gmail.com>
Subject: Re: [PATCH v3] skbuff: fix a data race in skb_queue_len()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     cai@lca.pw, Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Useful playground: https://godbolt.org/z/i7JFRW
