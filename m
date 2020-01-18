Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32571418FE
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 19:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgARSjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 13:39:21 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34038 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgARSjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 13:39:21 -0500
Received: by mail-oi1-f194.google.com with SMTP id l136so25220318oig.1;
        Sat, 18 Jan 2020 10:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zj5eFaZ3ZgnaYL2yLmVNHklssUHzuH7vw7dXpd3eIZE=;
        b=R0qhw5cKWZAbJnu/kSC0bnjICJYaLebPQ5HaC+1rgSxU9x5qRYEM4o3VU8lQIkmmVp
         rKghr+Hv1vX7ZRRpnkUBxiRFETZKxfsHoOPmNpKbn/CG/QbsLQH0huQFWvrdiC2trydi
         SIHNTyrT8Ml1nvk885WEozMOqz9RjU8UhBrbRuE+VNJ86M+WlfCI8NFZR8qEbkG1uWJe
         VR3vqkcyr3/wngBaKnaZxzUBD5CNOqEBh1p5PG1mTUNlgWiTb1CoTVMNxUN7Z6pLJMhD
         9yjDJ9aOKHCfsXm7ljbygx4ddmo2G9nzeCIu9Qa0NtvYgW09+rDUdOd0MpQDS21NffvW
         FWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zj5eFaZ3ZgnaYL2yLmVNHklssUHzuH7vw7dXpd3eIZE=;
        b=eWuX1IKnry3dD4YWTL/RPwOQDTYSXLDUHpCgx9vAg82wfl2oBBxmimbjIPllSrdTIs
         RDPJFJZ/xLTxdAWIrUhnf92HCl6TKlbA9Q0Usn4rR5eE/M8cQf5yOr8OKt0X7LCIt/mr
         eM9p/8oJDSejpwUeEoRk7segzKhjtuOWEtRWzwWH1BOdaGwUHPDbHMxWufZ590odyTl6
         py1zM0JxM5l+zNwRPwR9ZMQc+/4lS3/ab1r9532lXL7VxqllVHhYg1H0BGElAHvJklJn
         l0czkXjPdbfMkCmdhVH81BkF8A9mbDjih6se+ex1mHmlNIL6l7+y8dvZlfYLixaylxvU
         828A==
X-Gm-Message-State: APjAAAX+k66+el+QwMYkUpo0lkEoYRR+7GpVLCy/0/X5xRXEaPvnC4n1
        N2DROHsGEGxf5jUIeBZL1Ru2mBAsXL5zm2A+JHw=
X-Google-Smtp-Source: APXvYqyQ24vVuAFZMniXzT83d3ez3LwtzFKUEn5mINQTZRMOcZrzHmpTm8sc37NmSXHou3Bu1JYU+W+I5pM6I9dnVuM=
X-Received: by 2002:aca:1e11:: with SMTP id m17mr7967028oic.5.1579372760498;
 Sat, 18 Jan 2020 10:39:20 -0800 (PST)
MIME-Version: 1.0
References: <00000000000075aa7d059c6cab3c@google.com>
In-Reply-To: <00000000000075aa7d059c6cab3c@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 18 Jan 2020 10:39:09 -0800
Message-ID: <CAM_iQpX-CHUb7UVnADxk1J6ZQtx4-F6CiT+hbWw09=27pc1daA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in bitmap_port_destroy
To:     syzbot <syzbot+8ccfc03b082d0ab9b84b@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        florent.fourcot@wifirst.fr, Florian Westphal <fw@strlen.de>,
        jeremy@azazel.net, Johannes Berg <johannes.berg@intel.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: netfilter: fix a use-after-free in mtype_destroy()
