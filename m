Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77800334AB
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 18:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbfFCQNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 12:13:52 -0400
Received: from defiant.darkvoyage.org.uk ([81.187.177.18]:53374 "EHLO
        defiant.darkvoyage.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfFCQNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 12:13:52 -0400
X-Greylist: delayed 1107 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jun 2019 12:13:50 EDT
Received: from [172.20.0.44] (port=59724)
        by defiant.darkvoyage.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-SHA:256)
        (Exim 4.87)
        (envelope-from <a8b707e26f6083d@tengu.darkvoyage.org.uk>)
        id 1hXpIl-0001uq-SV; Mon, 03 Jun 2019 16:55:11 +0100
Message-ID: <5CF54288.6080408@tengu.darkvoyage.org.uk>
Date:   Mon, 03 Jun 2019 16:53:44 +0100
From:   Iain Paton <a8b707e26f6083d@tengu.darkvoyage.org.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clabbe.montjoie@gmail.com
CC:     nathan@traverse.com.au, dwmw2@infradead.org
Subject: BUG solos-pci /sys parameters can't be accessed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit e94d91a6eb155ff77110863d15ba51b3c6b5c548 
atm: solos-pci: Replace simple_strtol by kstrtoint
causes access to any solos parameters under /sys/class/atm/solos-pci[n]/parameters
to fail, for example:

root@solos:/sys/class/atm/solos-pci0/parameters# cat State
cat: State: Input/output error

loading the module with atmdebug=1 shows that communication with the 
card is working

[  296.599161] solos 0000:03:01.0: Transmitted: port 0
[  296.599168] solos 0000:03:01.0: size: 13 VPI: 0 VCI: 0
[  296.599176] 00: 4C 30 31 31 31 38 0A 53 
[  296.599181] 08: 74 61 74 65 0A 

[  296.616012] solos 0000:03:01.0: Received: port 0
[  296.616027] solos 0000:03:01.0: size: 17 VPI: 0 VCI: 0
[  296.616039] 00: 4C 30 31 31 31 38 0A 48 
[  296.616049] 08: 61 6E 64 53 68 61 6B 65 
[  296.616052] 10: 0A 

and we're receiving the expected response.

The reason is in the following section

@@ -428,7 +432,9 @@ static int process_command(struct solos_card *card, int port, struct sk_buff *sk
            skb->data[6] != '\n')
                return 0;
 
-       cmdpid = simple_strtol(&skb->data[1], NULL, 10);
+       err = kstrtoint(&skb->data[1], 10, &cmdpid);
+       if (err)
+               return err;
 
        spin_lock_irqsave(&card->param_queue_lock, flags);
        list_for_each_entry(prm, &card->param_queue, list) {

as kstrtoint want's the input string to be as follows:

"The string must be null-terminated, and may also include a single 
newline before its terminating null. The first character may also be 
a plus sign or a minus sign."

this usage of kstrtoint will always fail as what's being passed in is 
not a simple null terminated string, rather it's a multi-value string 
where each value is seperated with newlines.

Reverting the patch sorts it, but doesn't really seem like the right 
thing to do.

Iain
