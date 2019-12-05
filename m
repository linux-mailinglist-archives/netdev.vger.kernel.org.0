Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598D6113971
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 02:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfLEB53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 20:57:29 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35626 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfLEB52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 20:57:28 -0500
Received: by mail-lf1-f67.google.com with SMTP id 15so1182854lfr.2;
        Wed, 04 Dec 2019 17:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wB2iKdYbnrvcS7iCPzGVqbYFHk5+Z6aAqzKuHWp0eu8=;
        b=QOerjfOBw920PTvSrAaWcYuQCXa7uLj+5AqqYhyO1HdOJR5LgXVWG4AD1gWChIrkXX
         bytaKReLnpz5SVBmGP3yp+ttrDeN2p2gXpKcgIplYhgQTzu8FLYjEUCUbebWweXknbDv
         kjNXOoWekDHSZmgHOHdOLAUD6vDbG/ejhcvagQWO9GtF/iLK7HkeTzO6QI/bxcXzZcI/
         KPQOByG3Sm3RabPF6HKkPfWrEuwQ7QB8vsTLJGzOnIU06djimvhmmP+4usTVqBWKYuFv
         0H107AtG3zdGzJrE8+91U9M0PWBHt7vleuWlkuLv8gmG/Hor4BQ8YKGPMO4lA55vsSdF
         VRbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wB2iKdYbnrvcS7iCPzGVqbYFHk5+Z6aAqzKuHWp0eu8=;
        b=RYzcQ4MKTkcvbAZ1PuFx2bW70sMgST32W+RuB3cqDs3YWa2N4duLLMJshRn4rqeoKy
         dNv7kn6YWB3eNxBD5SNr5evIi7kTBpuIEX8tAi08jpI7IY7hb2rVInsLFyyqwINyTFx3
         Dk9KieyKyKuE8m+0JLtIBFe3wG16ntuS1Aqo72I1TeCWpdveCQrfn4Gjz/WJQa2Qaxqv
         71jhCpSBYZ9/FPRr9uoKr9wcMO52JlZi61tDVgguTs8DUAbbuqLuK/cHI3rnqB2pTAt/
         ejO1Rra+0mc3NUmYETggKhwx6Z1DeZfrCzc0PDkJ/3fsDBcbmOh4V4gM6TdtyYZ2000F
         e0Jw==
X-Gm-Message-State: APjAAAU3Q516/jHkzOVXv1uISbBtDLmA5wlgJ8DT9BueknkgnkMV1PYI
        VG+2HEElApeqlGXKpf/JlrR3NFVvthJgmwHRJmU=
X-Google-Smtp-Source: APXvYqyOmdyQpRDOPWWb8nK3TIfxuvdAjbsqj+BxFanqZWYxvN8PXQgEQc3E6GkELkkOZDzboQb9hUbnD/dlAb8ICok=
X-Received: by 2002:a19:9149:: with SMTP id y9mr3946061lfj.15.1575511046634;
 Wed, 04 Dec 2019 17:57:26 -0800 (PST)
MIME-Version: 1.0
References: <20191202200143.250793-1-sdf@google.com>
In-Reply-To: <20191202200143.250793-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 4 Dec 2019 17:57:15 -0800
Message-ID: <CAADnVQKMW0v6dxQ3DN6CcyDFRCE2cGC-ha-Ab0wTtv5qaXgk1Q@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: don't hard-code root cgroup id
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 12:01 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Commit 40430452fd5d ("kernfs: use 64bit inos if ino_t is 64bit") changed
> the way cgroup ids are exposed to the userspace. Instead of assuming
> fixed root id, let's query it.
>
> Fixes: 40430452fd5d ("kernfs: use 64bit inos if ino_t is 64bit")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied. Thanks for the fix!
