Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7421507AEB
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 22:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354068AbiDSU3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 16:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbiDSU3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 16:29:21 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA65366A7;
        Tue, 19 Apr 2022 13:26:37 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9f:8600:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 23JKPvrg1019330
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 21:25:59 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8602:8cd5:a7b0:d07:d516])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 23JKPsx11417014
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 22:25:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1650399957; bh=GL1yC0TQSRHkqmV/DSr+k6th0pBM0w7r0/8fvjcp1gQ=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=N9XJCaG7CkPGlMm9+pIlPrXlHhqrZ26J43Ph+m4WbC7YPXplpV4mz+PSFefJbgrP3
         wA5/ElIgfAPeVymYuL0n696i2vaJWOy0YQamWajOMi6L/UOPOCg6fAcx5x9U5Blb75
         6fum5px+jibp89M1pvOY0iFtyjirVjbBnTpJIsJE=
Received: (nullmailer pid 913495 invoked by uid 1000);
        Tue, 19 Apr 2022 20:25:54 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        USB <linux-usb@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
Organization: m
References: <20220409120901.267526-1-dzm91@hust.edu.cn>
        <YlQbqnYP/jcYinvz@hovoldconsulting.com>
        <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
        <d851497f-7960-b606-2f87-eb9bff89c8ac@suse.com>
Date:   Tue, 19 Apr 2022 22:25:54 +0200
In-Reply-To: <d851497f-7960-b606-2f87-eb9bff89c8ac@suse.com> (Oliver Neukum's
        message of "Tue, 19 Apr 2022 13:47:40 +0200")
Message-ID: <871qxsrfal.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.5 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com> writes:

> It seems to me that fundamentally the order of actions to handle
> a hotunplug must mirror the order in a hotplug. We can add more hooks
> if that turns out to be necessary for some drivers, but the basic
> reverse mirrored order must be supported and I very much favor
> restoring it as default.

FWIW, I agree 100% with this.  Please go ahead with the revert of commit
2c9d6c2b871d ("usbnet: run unbind() before unregister_netdev()").

AFAICS, your proposed new hook should solve the original problem just
fine.


Bj=C3=B8rn





