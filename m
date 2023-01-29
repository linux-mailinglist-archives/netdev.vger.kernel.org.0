Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667D8680033
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 17:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjA2QVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 11:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2QVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 11:21:08 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6F610ABA
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 08:21:06 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D5E532007D;
        Sun, 29 Jan 2023 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675009264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wlHR5zI8g14xm8ZfvQ5v6PsdHga0Kh0Wc6E2t6OoFNE=;
        b=xUMX10PbNna+Tb4PO+UKPVKtbkPCFXRwlAohf2vJ+zMw9+Ghv/fi9O2AZK/a+cNyjp6L2q
        8og8ZdPMuju9vens89hbgpL/7K/flYTXBcEoiD/eTsi0SV3boEtriMgTnFj2MAchSIov7I
        5ZnqtytH7Mnakkt48DWT//QltEw7cB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675009264;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wlHR5zI8g14xm8ZfvQ5v6PsdHga0Kh0Wc6E2t6OoFNE=;
        b=ekADnEHh5GxifMP+5q2/vIYVO5+gM8gUyijmt0EnZofalkpeek1jUyATd1RQWXsZUzKxAB
        1emRguTT3N92gPAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A5A6B13583;
        Sun, 29 Jan 2023 16:21:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zJFnJ/Cc1mO2dAAAMHmgww
        (envelope-from <hare@suse.de>); Sun, 29 Jan 2023 16:21:04 +0000
Message-ID: <048cba69-aa9a-08d1-789f-fe17c408cfb2@suse.de>
Date:   Sun, 29 Jan 2023 17:21:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com, bcodding@redhat.com,
        jlayton@redhat.com
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230128003212.7f37b45c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/23 09:32, Jakub Kicinski wrote:
> On Thu, 26 Jan 2023 11:02:22 -0500 Chuck Lever wrote:
>> I've designed a way to pass a connected kernel socket endpoint to
>> user space using the traditional listen/accept mechanism. accept(2)
>> gives us a well-worn building block that can materialize a connected
>> socket endpoint as a file descriptor in a specific user space
>> process. Like any open socket descriptor, the accepted FD can then
>> be passed to a library such as GnuTLS to perform a TLS handshake.
> 
> I can't bring myself to like the new socket family layer.
> I'd like a second opinion on that, if anyone within netdev
> is willing to share..

I am not particularly fond of that, either, but the alternative of using 
netlink doesn't make it any better
You can't pass the fd/socket directly via netlink messages, you can only 
pass the (open!) fd number with the message.
The fd itself _needs_ be be part of the process context of the 
application by the time the application processes that message.
Consequently:
- I can't see how an application can _reject_ the message; the fd needs 
to be present in the fd table even before the message is processed, 
rendering any decision by the application pointless (and I would _so_ 
love to be proven wrong on this point)
- It's slightly tricky to handle processes which go away prior to 
handling the message; I _think_ the process cleanup code will close the 
fd, but I guess it also depends on how and when the fd is stored in the 
process context.

If someone can point me to a solution for these points I would vastly 
prefer to move to netlink. But with these issues in place I'm not sure 
if netlink doesn't cause more issues than it solves.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

