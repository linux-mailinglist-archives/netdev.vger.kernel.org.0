Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BF43DAC2D
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 21:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhG2TxZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Jul 2021 15:53:25 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54829 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhG2TxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 15:53:24 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id 994FFCED1E;
        Thu, 29 Jul 2021 21:53:19 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v3 2/2] Bluetooth: fix inconsistent lock state in
 rfcomm_connect_ind
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210721093832.78081-3-desmondcheongzx@gmail.com>
Date:   Thu, 29 Jul 2021 21:53:19 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Transfer-Encoding: 8BIT
Message-Id: <06E57598-5723-459D-9CE3-4DD8D3145D86@holtmann.org>
References: <20210721093832.78081-1-desmondcheongzx@gmail.com>
 <20210721093832.78081-3-desmondcheongzx@gmail.com>
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Desmond,

> Commit fad003b6c8e3d ("Bluetooth: Fix inconsistent lock state with
> RFCOMM") fixed a lockdep warning due to sk->sk_lock.slock being
> acquired without disabling softirq while the lock is also used in
> softirq context. This was done by disabling interrupts before calling
> bh_lock_sock in rfcomm_sk_state_change.
> 
> Later, this was changed in commit e6da0edc24ee ("Bluetooth: Acquire
> sk_lock.slock without disabling interrupts") to disable softirqs
> only.
> 
> However, there is another instance of sk->sk_lock.slock being acquired
> without disabling softirq in rfcomm_connect_ind. This patch fixes this
> by disabling local bh before the call to bh_lock_sock.

back in the days, the packet processing was done in a tasklet, but these days it is done in a workqueue. So shouldn’t this be just converted into a lock_sock(). Am I missing something?

Regards

Marcel

