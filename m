Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A422015F9FA
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 23:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgBNWxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 17:53:37 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47059 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbgBNWxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 17:53:37 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c1c0a495
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 22:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=3+Qlztex9Zyw/MhrfBtIeOoX4sU=; b=rV8Kpf
        csFYWxg1PVaSNuwMiHiLuBBVbVhbQmHocA8i3wMpJ8yOWrUeG97OZwrhNdrwK+bs
        AmeIuCoEj7kXNDYVvOLWcfsb+351V0eF1x0D+I0R8sCIvpkMu+7zQgL1dBOeyKp1
        X/J/F04YT446yOOKsIIAeJZYqU9BXyOerW8YJsZ/bhleeqPYMd2RYYiMDRDnadC6
        0NfQwgrm1QLxIG/jAtzarN4BxM1UujpldWYfoHksdY54UFMn6vQaw3Ip9Rcr5kxR
        PiXOqSULxseEBc58zY9KUK0kW2wg09ZXQgwhYq0eh/OkORz0N7XblaMX9Mbs0div
        S3fgVvT1tVOUMVGQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2e5fc1f1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 22:51:25 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id 66so10694657otd.9
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 14:53:34 -0800 (PST)
X-Gm-Message-State: APjAAAWTOB1vlv4622BDI/8j/ah4WmkQ757CZlvd/4pLgMNPe2TSYbSW
        5xRNVQI0Bk6z4lZ8EZqSMjOz+vLdJlkO288LlX8=
X-Google-Smtp-Source: APXvYqxbQAmY+aem1wuZUa5aiIiUJcrayX0jmT5hvWvxcmgOvmwi7xGp4kTJAEuJatg9HxdsG6DAzCxvSx75VuxRjNw=
X-Received: by 2002:a9d:7a47:: with SMTP id z7mr4209430otm.179.1581720814047;
 Fri, 14 Feb 2020 14:53:34 -0800 (PST)
MIME-Version: 1.0
References: <20200214173407.52521-1-Jason@zx2c4.com> <20200214173407.52521-4-Jason@zx2c4.com>
 <135ffa7a-f06a-80e3-4412-17457b202c77@gmail.com> <CAHmME9pjLfscZ-b0YFsOoKMcENRh4Ld1rfiTTzzHmt+OxOzdjA@mail.gmail.com>
 <e20d0c52-cb83-224d-7507-b53c5c4a5b69@gmail.com> <CAHmME9oXfDCGmsCJJEuaPmgj7_U4yfrBoqi0wRZrOD9SdWny_w@mail.gmail.com>
 <ec52e8cb-5649-9167-bb14-7e9775c6a8be@gmail.com> <CAHmME9r6gTCV8cpPgyjOVMWCbRJtswzqXMYBqTQmo001AZz05Q@mail.gmail.com>
 <1b132351-d4a7-851c-ac98-0a48c8d90797@gmail.com>
In-Reply-To: <1b132351-d4a7-851c-ac98-0a48c8d90797@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Feb 2020 23:53:23 +0100
X-Gmail-Original-Message-ID: <CAHmME9ok5ktHCvn0o1M-qjK68He-AsKJvKQMPkWnZL7Tq1GWVw@mail.gmail.com>
Message-ID: <CAHmME9ok5ktHCvn0o1M-qjK68He-AsKJvKQMPkWnZL7Tq1GWVw@mail.gmail.com>
Subject: Re: [PATCH v2 net 3/3] wireguard: send: account for mtu=0 devices
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 11:30 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Also note that UDP sockets have SOCK_RCU_FREE flag set, so core
> networking also respect one RCU grace period before freeing them.

       if (use_call_rcu)
               call_rcu(&sk->sk_rcu, __sk_destruct);
       else
               __sk_destruct(&sk->sk_rcu);

Ah, that's handy indeed.

> It is possible that no extra synchronize_{net|rcu}() call is needed,
> but this is left as an exercise for future kernels :)

Cool, yea, sounds like something I should play with for 5.7.

Sending v3 out in a few minutes.
