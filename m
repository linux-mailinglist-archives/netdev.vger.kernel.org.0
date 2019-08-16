Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18F9901F1
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfHPMsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:48:32 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35890 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfHPMsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 08:48:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so1445569wrt.3;
        Fri, 16 Aug 2019 05:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gdVAyJbKzHtUas+0+o6fqj0G7LO7nGfIwyqZgFQ2Jtw=;
        b=ulDEdRzEUH8ETwpn8XqY5dIWfukjD3mf4eRxumgFU7a4M6lHZLgdRr9KVpKtivzIja
         1NGIK99AAUoB6w4anAwijNy+qRTcCcD7gLUqAWVfW61i43ioa3pQvBjzBUFHUpJoa0GA
         BloO5UCchMPm+ojeiwQ1M8lxGfeOp9sCOotZ9wp7pEGpLr4EJHJW50B/T8xIinZZMd5R
         odkILibkFT1tA6tPVrVGWntvbNQWvYjXu8aD+7SMn+iiPXpECFChuM/mnJ0ItMPBdWdo
         6PxM6xeeQkWoop3hMXMU0PIXDm2gm7hGi+1ebw/utZTNNMJyHve1BlUlbI2KDbTuHWRw
         mXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gdVAyJbKzHtUas+0+o6fqj0G7LO7nGfIwyqZgFQ2Jtw=;
        b=VTYahtHsrTEalQ1x+JHVgtvqNThVDbzLY5puRQkWc933EdKqVoiEMfp9I7G8qkJU0A
         stNVuGivftrbfzcSIzgHj1+jEciUCrcG/FGeZgDNvYbCZUDw851ExowyNx8NcWKAnJfr
         /WRFPRwBGgu+aKmfevy+ts73UW8tH1w0vIrce2wwaXRny+imYfQWZ4M8IqsMqcD9LVJu
         hPgUENGqOkCxq1mO1rLu6JCxvLkPxSVhCz9Uj0k0ceQebzB7FwZFFZT68fpcogOg0EHB
         1bjcrbNwcibOjC5Xpok96z7K9EExaPOfW3s2bvGaC9G9AhNW8R4GGLC70j8/HoWt4fh5
         4now==
X-Gm-Message-State: APjAAAVrSU9HCjklkv8viTFyE0Gk1ovDpkpGEQxW0MKBz157Xs9RyPfx
        QpfojvDL5RPX9ZvuMjZb+w77xabitA+SJkycy/fPCZxy
X-Google-Smtp-Source: APXvYqyxPH9aW3FqUle7zpXisvCf3oR92FR+98HoNP1GDcJLjSwjgRGREyDzVFikQzHrJH6doZBVE16aErk2H47LvHo=
X-Received: by 2002:adf:9043:: with SMTP id h61mr4366047wrh.247.1565959708854;
 Fri, 16 Aug 2019 05:48:28 -0700 (PDT)
MIME-Version: 1.0
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Fri, 16 Aug 2019 18:18:21 +0530
Message-ID: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
Subject: Unable to create htb tc classes more than 64K
To:     netfilter-devel@vger.kernel.org, lartc <lartc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I want to have around 1 Million htb tc classes.
The simple structure of htb tc class, allow having only 64K classes at once.
But, it is possible to make it more hierarchical using hierarchy of
qdisc and classes.
For this I tried something like this

tc qdisc add dev eno2 root handle 100: htb
tc class add dev eno2 parent 100: classid 100:1 htb rate 100Mbps
tc class add dev eno2 parent 100: classid 100:2 htb rate 100Mbps

tc qdisc add dev eno2 parent 100:1 handle 1: htb
tc class add dev eno2 parent 1: classid 1:10 htb rate 100kbps
tc class add dev eno2 parent 1: classid 1:20 htb rate 300kbps

tc qdisc add dev eno2 parent 100:2 handle 2: htb
tc class add dev eno2 parent 2: classid 2:10 htb rate 100kbps
tc class add dev eno2 parent 2: classid 2:20 htb rate 300kbps

What I want is something like:
tc filter add dev eno2 parent 100: protocol ip prio 1 handle
0x00000001 fw flowid 1:10
tc filter add dev eno2 parent 100: protocol ip prio 1 handle
0x00000002 fw flowid 1:20
tc filter add dev eno2 parent 100: protocol ip prio 1 handle
0x00000003 fw flowid 2:10
tc filter add dev eno2 parent 100: protocol ip prio 1 handle
0x00000004 fw flowid 2:20

But I am unable to shape my traffic by any of 1:10, 1:20, 2:10 or 2:20.

Can you please suggest, where is it going wrong?
Is it not possible altogether?

-Akshat
