Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA66A96894
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 20:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbfHTS1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 14:27:47 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:36066 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbfHTS1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 14:27:46 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id D248B65934
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 11:27:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com D248B65934
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1566325665;
        bh=a0gNksfCPyRPHwx3+ioCoC142WPAEXpyjC4d0Dwwin8=;
        h=To:From:Subject:Date:From;
        b=hWuzJXNP7LXeAs97T4voBBRqLz1sN2WJBogfY5l1X0ie6cxCCssHBoDytwbqjcoTu
         dE7lrUgtzMCmFwCc4MUiqKC05JtBlWOrtnhwxgrl5z/slMnsZFa+bfPq0W+/kUZcli
         gNOO6K486nieVWF1AdNFenM2fa0F/zoSwAtJYodU=
To:     netdev <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: VRF notes when using ipv6 and flushing tables.
Organization: Candela Technologies
Message-ID: <8977a25e-29c1-5375-cc97-950dc7c2eb0f@candelatech.com>
Date:   Tue, 20 Aug 2019 11:27:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I recently spend a few days debugging what in the end was user error on my part.

Here are my notes in hope they help someone else.

First, 'ip -6 route show vrf vrfX' will not show some of the
routes (like local routes) that will show up with
'ip -6 route show table X', where X == vrfX's table-id

If you run 'ip -6 route flush table X', then you will loose all of the auto
generated routes, including anycast, ff00::/8, and local routes.

ff00::/8 is needed for neigh discovery to work (probably among other things)

local route is needed or packets won't actually be accepted up the stack
(I think that is the symptom at least)

Not sure exactly what anycast does, but I'm guessing it is required for
something useful.

You must manually re-add those to the table unless you for certain know that
you do not need them for whatever reason.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

