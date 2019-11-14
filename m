Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB6FFC297
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfKNJaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:30:11 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38688 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfKNJaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:30:11 -0500
Received: by mail-lj1-f193.google.com with SMTP id v8so5887618ljh.5
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 01:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=+fNlJipTGPK8BbAzho/WSvngQKFh5pffFcbOs08mOP8=;
        b=RyBeUVWfWron+hgHXPrP8PdpBaFebF6FIEyE3FWuF9Hj3zkihQ9MX3ekXKa23F/fs8
         EoquTFbqzkQx7yLcvPxQ7EeeW27cTDF3jx9XXlBUBBOLsdWch9oVhIUOeSNDjVebjLgm
         9tb9hDekTb7hS2HSFrj0Gh2QWRNueg0Uv6HajJczpKFcVWsbggCXw79YM6jDxuIxZxBl
         nWD9iL7Ir+ydWm4OIYmcQLIcnBYhWQoJ8YHJwE11YAX6LEqm6jFZRQSM0DsCEeRsfRU3
         rScbUO+mZKJlQviGG74F+XbmjjzGjG1YfsJ3ionK0shUCJPRkaK2SZtPbAzPpgzVCMRQ
         +y2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=+fNlJipTGPK8BbAzho/WSvngQKFh5pffFcbOs08mOP8=;
        b=a7lBRO8tnlHv68OhAZk76rfKs/9IbMbYNWgOrxJ1N/6EBCoNEUofF1T6pLhAUrj7j4
         TBxMKyAgPUReigKb2lxoGAfioHllej917VBG2DA5di/rl4O/qdO0AjUWQ/EHJJ8DkAos
         qISnM/wwC3yzq6zDfEfz1M89dlzz4mGovasGxFMZ4ceLhF6OW8+p67F10Pn+jMx1jDdx
         Wbmw2fARJ/sMjf1kYhhbTp31rX5TPXm7x/4/FAzEKGr/eQsY0HmRMjB7XUz60fXaGkLD
         uh6T6ALZVLW3m2P1kwkwiF0VF/i59b1g995EGJh2zapWArBj6tsD0AEaDWkKhudRLTuo
         ULmg==
X-Gm-Message-State: APjAAAUwn2HjsK1MqE+fBvG3dotpx2EhosMi7jDhPXwBl5djTyo0Hgo/
        s/3C28cdGAVoGDMeV5/n26FRbw==
X-Google-Smtp-Source: APXvYqyvP29IJwX2BVcrfHdc4YNDeX5tEznHwriR4JYr6UDGtryh3ylTP6sH2b8YShaFTu8h3rRYhA==
X-Received: by 2002:a2e:8597:: with SMTP id b23mr6033941lji.218.1573723809096;
        Thu, 14 Nov 2019 01:30:09 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id z17sm1901921ljm.16.2019.11.14.01.30.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Nov 2019 01:30:08 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, socketcan@hartkopp.net,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH] slip: Fix memory leak in slip_open error path
References: <20191113114502.22462-1-jouni.hogander@unikie.com>
        <87sgmqapi4.fsf@unikie.com>
        <20191114.010935.1214456698424489397.davem@davemloft.net>
Date:   Thu, 14 Nov 2019 11:30:07 +0200
In-Reply-To: <20191114.010935.1214456698424489397.davem@davemloft.net> (David
        Miller's message of "Thu, 14 Nov 2019 01:09:35 -0800 (PST)")
Message-ID: <87d0duajq8.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: jouni.hogander@unikie.com (Jouni H=C3=B6gander)
> Date: Thu, 14 Nov 2019 09:25:23 +0200
>
>> Observed panic in another error path in my overnight Syzkaller run with
>> this patch. Better not to apply it. Sorry for inconvenience.
>
> I already did, please send a revert or a fix.

I found out (and commented on patch) that the panic was caused by another e=
rror
path fix I had in my Syzkaller setup. This patch is ok, no need to revert.

BR,

Jouni H=C3=B6gander
