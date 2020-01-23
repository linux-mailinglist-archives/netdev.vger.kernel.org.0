Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 784CF14702C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgAWR6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:58:41 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34590 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgAWR6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:58:41 -0500
Received: by mail-lf1-f68.google.com with SMTP id l18so3035081lfc.1
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 09:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :subject:to:cc:from:message-id;
        bh=9PZb53gn3HlYV30IW/3Iin0xPniNCS5s4n7brqy6NFs=;
        b=cv/awR2y1PRHqf6zaD9Uia66fk7WiFyzcNZ3UBvU4btFuYJlOUEwQ0F9cG89sWoVC+
         /CujA9UE+XK+DhVYW7fU8SKZVIcVIYvSGcUQco44WeSfyacHnHD+omZ5rOhZ+LjYiZxw
         YML6rS+jM7HfWvQQCvV09Dh/SQ1E3KsVNnJKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=9PZb53gn3HlYV30IW/3Iin0xPniNCS5s4n7brqy6NFs=;
        b=aH5PghUu4/8RDdds5WAaji9l0DNbBm3BHpDj5GpcxPjM+ZnxU2HesxRaCLlroqZNKG
         1UZqIkyqIsvFGW3WMc1A1YgvYmyYPDlSNKRuxJMQsr28EPbEeD6xrZlVEMRm/dpoW7oC
         mIEG7io/cIM8apBDiMMkPs5d2xAeeGKY5imSQX7pOBCZeH6j8Sq3ZZW8bQt3wauYxhFJ
         0FaHVMYgDfAA/XKPO+bxIIb8NAKOCh9BtMLJyFv7mPaQXRlh4Eg6uxJbXt9gmMksswBQ
         t5VdAGR085bgDXNXTQfjNMjZ5GBbJsVolUtnCmYTyPvQ8IjeAVTGENBDpZ3BnUzTsczY
         fmKw==
X-Gm-Message-State: APjAAAU3aODxE9Nd30hPGnNtIIHPPab/iRBndeBeQUbNHuDT6RCpizmt
        l62tcwrQtaUPzmNOa7zYV+I0b72yeSg=
X-Google-Smtp-Source: APXvYqxzXniVD7W//rQr8q3tMwZteJwThhLh6xKvg5JLT79tWfpZn8Yuhfqxj9uz13D7Ywztb+KLSw==
X-Received: by 2002:a19:760c:: with SMTP id c12mr5257474lff.60.1579802319215;
        Thu, 23 Jan 2020 09:58:39 -0800 (PST)
Received: from localhost (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b17sm1449130lfp.15.2020.01.23.09.58.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jan 2020 09:58:38 -0800 (PST)
Date:   Thu, 23 Jan 2020 19:58:35 +0200
In-Reply-To: <20200123082542.06ed0a53@hermes.lan>
References: <20200123132807.613-1-nikolay@cumulusnetworks.com> <20200123132807.613-2-nikolay@cumulusnetworks.com> <20200123082542.06ed0a53@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next 1/4] net: bridge: check port state before br_allowed_egress
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org
From:   nikolay@cumulusnetworks.com
Message-ID: <B878D56B-BA6C-49A9-877D-5590BC4DC314@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 January 2020 18:25:42 EET, Stephen Hemminger <stephen@networkplumber=
=2Eorg> wrote:
>On Thu, 23 Jan 2020 15:28:04 +0200
>Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom> wrote:
>
>>  	return ((p->flags & BR_HAIRPIN_MODE) || skb->dev !=3D p->dev) &&
>> -		br_allowed_egress(vg, skb) && p->state =3D=3D BR_STATE_FORWARDING &&
>> +		p->state =3D=3D BR_STATE_FORWARDING && br_allowed_egress(vg, skb) &&
>>  		nbp_switchdev_allowed_egress(p, skb) &&
>>  		!br_skb_isolated(p, skb);
>>  }
>
>Maybe break this complex return for readability?

Sure, sounds good, but is not the point of this commit=2E=20
I'll prepare a separate cleanup patch for that=2E=20

Thanks,=20
  Nik

