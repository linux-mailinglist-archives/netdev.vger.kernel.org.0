Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CCE1894D9
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgCREXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:23:14 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:41129 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgCREXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:23:13 -0400
Received: by mail-il1-f195.google.com with SMTP id l14so22347896ilj.8;
        Tue, 17 Mar 2020 21:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0jhvppohiGdkVH4kDUuCkzpSB1MhlV8OnkUGzMM6rqA=;
        b=RDet+2Z+Lfi2S7uCJcx3wrx3jgthVPCp1iaSHTRXmtgG/JAFqfO+94wXHET7LnU4SN
         FExE5CQ2if5LZ5P+8B7OPd67iAOyXKQqYiKOZ94kod+p+QNOaepENep/c+kBg/LQOwpH
         VFt14LAiWmknu+haC8uUXDw6UGqt2EuTH/4TYDt/5dkFWN83pzTXWm29nKiP7k+/uI/n
         lgFRN9lk78zxx4dkBHuiLM1Hjhaj33GB7nwDpBE9E3wn1rB8qdxqFISA7piqy8SkSTag
         1iDIs6yePatVtKRWexYOf5I47yy8jhzubz4KbvrdZImiTdMAXRzUhifKC/ah0vQCfZXA
         c0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0jhvppohiGdkVH4kDUuCkzpSB1MhlV8OnkUGzMM6rqA=;
        b=F1xyAlOnsrZx2+8FR1/cJ5X8sXTtu3cMKjEPWQXj2TDnTeUXPV6RWHVhGNV5jxy84t
         tHQTnBbC6EZxJ8MXZi6vmOTQIQ306pXDo8SiZy7NVgaE220o1Vsn9GDlvjCfoNWwVBlf
         2sRIWZJD0i9iU8AErIqSfJmoAOGPxqQVg3AI1EU54ABfn9AxE8Buhfetav/xcOXtwA5a
         GLbeatcrjccXhSEBEgn3no/B+/HbKPbYaoqBhEhgJI6ihpO0Vsf+rZcTkJvDQAkxy6H0
         BIMnzeYFmcQyeDRfXkRlM6ko0buRt8cPktLb3p3T8xwZzrEKMUMBl9HvDYMm1NXv6x1R
         LXJA==
X-Gm-Message-State: ANhLgQ0BvL+WpEkNAq2KSQ9nm5flO51wxYU455XYssf6oAKlOgGh5l2Y
        XPSS0z471ATVj1ErlMNQV1LbgtRFYaZUj8u7Bmw=
X-Google-Smtp-Source: ADFU+vtqkCN72qjYs1Zx1mwfm2LXiYho3C9TjXQ2/kQEL1e+vz9pwGTwUIsgZpkniv9KTeOTWpYDb7vZoqR78EP07Bw=
X-Received: by 2002:a92:83ca:: with SMTP id p71mr2017072ilk.278.1584505390662;
 Tue, 17 Mar 2020 21:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200317155536.10227-1-hqjagain@gmail.com> <20200317173039.GA3828@localhost.localdomain>
 <CAJRQjocwMzmBiYXwCnupE7hd8qYveBXtUiF2WKBe=TFfJLqcDw@mail.gmail.com>
 <20200318035549.GC3756@localhost.localdomain> <CAJRQjoeGtALzDHUS+OUJfK-JqQ_T-_RX74Opt-TLTxufVAQN7g@mail.gmail.com>
In-Reply-To: <CAJRQjoeGtALzDHUS+OUJfK-JqQ_T-_RX74Opt-TLTxufVAQN7g@mail.gmail.com>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Wed, 18 Mar 2020 12:22:59 +0800
Message-ID: <CAJRQjofnjzO9ZZ12Ccxz1gBDiDt5Kt=E7Z2q4=vpcwY5AkOB9A@mail.gmail.com>
Subject: Re: [PATCH v2] sctp: fix refcount bug in sctp_wfree
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ T8813] [1]put skb 0xffff888099ebbe80 back. sctp_check_transmitted, 1533
[ T8813] [1]put back to queue 0xffff888096b2c280 sctp_check_transmitted, 1683
Something wrong happens here, 0xffff888099ebbe80 not changed to newsk
[ T8813] [1]before sk 0xffff88809621e7c0 sctp_sock_migrate, 9592

cause

[ T8811] [0]skb 0xffff888099ebbe80 0xffff8880a3bb2800: truesize
131328, sk alloc 296449 sctp_wfree 9101
               real sk 0xffff88809621e7c0

it's sk is still oldsk.
