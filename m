Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952AA15FF95
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 18:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgBOR6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 12:58:41 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:64892 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgBOR6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 12:58:41 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 48KdKB2NQCz9ty32
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 18:58:38 +0100 (CET)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=gWvc/VDG; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 2-dE1x4z0nHk for <netdev@vger.kernel.org>;
        Sat, 15 Feb 2020 18:58:38 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 48KdKB1GTHz9ty31
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 18:58:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1581789518; bh=JAWKczyJrNLAvy1segOKJq+8RRmreiNgnfaQX/nylpA=;
        h=Subject:References:To:From:Date:In-Reply-To:From;
        b=gWvc/VDG5Yeg4RvH0FKOI9W+pa0CVm9Jh+bKUZ9YZWwHZippXqzhLx0jrgkbsOTUH
         abnHN9F7Z3W5CWu7dIOtdmDknIahJuaIGmC7GAsN9RlLG1a3sbL7IYf7jn6Az/lBa7
         feI7p0fUklWp4P9RtTk0FDsa/iD3jb22NnWQYThs=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BDF838B797
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 18:58:39 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id BlR1yyELffzc for <netdev@vger.kernel.org>;
        Sat, 15 Feb 2020 18:58:39 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 85AEE8B755
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 18:58:39 +0100 (CET)
Subject: [netlink_bind()] [Bug 206525] BUG: KASAN: stack-out-of-bounds in
 test_bit+0x30/0x44 (kernel 5.6-rc1)
References: <bug-206525-206035-l8GOXmwaUO@https.bugzilla.kernel.org/>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
X-Forwarded-Message-Id: <bug-206525-206035-l8GOXmwaUO@https.bugzilla.kernel.org/>
Message-ID: <4c64dd30-b742-cc54-540d-f81f6f0ecc18@c-s.fr>
Date:   Sat, 15 Feb 2020 18:58:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <bug-206525-206035-l8GOXmwaUO@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




-------- Message transféré --------
Sujet : [Bug 206525] BUG: KASAN: stack-out-of-bounds in 
test_bit+0x30/0x44 (kernel 5.6-rc1)
Date : Sat, 15 Feb 2020 17:52:44 +0000
De : bugzilla-daemon@bugzilla.kernel.org
Pour : linuxppc-dev@lists.ozlabs.org

https://bugzilla.kernel.org/show_bug.cgi?id=206525

--- Comment #3 from Christophe Leroy (christophe.leroy@c-s.fr) ---
Bug introduced by commit ("cf5bddb95cbe net: bridge: vlan: add rtnetlink 
group
and notify support")

RTNLGRP_MAX is now 33.

'unsigned long groups' is 32 bits long on PPC32

Following loop in netlink_bind() overflows.


                 for (group = 0; group < nlk->ngroups; group++) {
                         if (!test_bit(group, &groups))
                                 continue;
                         err = nlk->netlink_bind(net, group + 1);
                         if (!err)
                                 continue;
                         netlink_undo_bind(group, groups, sk);
                         goto unlock;
                 }


Should 'groups' be changes to 'unsigned long long' ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
