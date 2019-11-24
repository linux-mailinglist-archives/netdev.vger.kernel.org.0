Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D90108564
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 23:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKXWuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 17:50:14 -0500
Received: from mail-qt1-f175.google.com ([209.85.160.175]:35639 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfKXWuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 17:50:14 -0500
Received: by mail-qt1-f175.google.com with SMTP id n4so15103944qte.2
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 14:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=eOTlnCq7KrU+J/eaNizjfNyp9YXeKQB+VhEtHXH7KFE=;
        b=oFtZIAw0fdNe9gfAfLSSv+hyH952EoSra91L32CdlZX7CbCDEtO+zb/DxD0wIeCZWz
         Wd78HjFNTWBF1bs7eK3R/xHn/pesKMqHx3nNx48mlTemOJQ03KpZg0w66vXJCCp74Ncp
         akCwAdxCoUSGCx6917utwYjXhcDD3G6pD7Ve49G7kA/qCdWvgTfZut+mcPoMIDXp9n8x
         z/1ReNvG+YBs+izdlrJe+Sv13FLUuJXanIZMGHNZAD05fs4/xsjQCnQuqWKeXbV06CRP
         K5HDGZGvqGkXwEAAjP8qiEFMzhEwRpZogB7oAuGKyomSplQW8DyIeSEVVXxAE3dNSJUL
         D3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=eOTlnCq7KrU+J/eaNizjfNyp9YXeKQB+VhEtHXH7KFE=;
        b=HLrofKKhjst69BA+6H+NGgEQn2N9pI5qndPBB7iuy1SHVWi4nY9QkCPY8ckg7q7Ybi
         hmnyTUL3aHVa4pUUi7+dsPjENRG7q2x6SXFT//LYo38ssRED0oqB6ElZmG8AdnvZMzmi
         fgFDyjr9/b+O7TsYd+e35sHQYBEb8zQBh3XqewG4BSFbP+KZ1SAlv9K4lNHtxXfPpgBE
         +MMRKXwRlU4cZJ/0qRTqmWSSi9OALUcsso7gKQSKsHbgt3n+AdQcBiase1n+9rJEMwWa
         VGosKzGPBG45LimnmSffzdNjMUWkQV8QR5uaBSnKiApXU4f9irdZV/KTpWR4f8Y6GuEu
         7/Gw==
X-Gm-Message-State: APjAAAVHBhFg2tIW9Xe2WBJr+EIpsMP2gyNAPiRQPMYdBfDowh3FJTHh
        UsTK3flnYsDgXgveJi+BZouCyADD
X-Google-Smtp-Source: APXvYqxfCZO9o1JRqWF0rVF/6xD/S84TPvJTeJciS34Aoic7+uUleKqO570TM4I+rn6W1kCeKcEt+Q==
X-Received: by 2002:ac8:5197:: with SMTP id c23mr18130024qtn.343.1574635813000;
        Sun, 24 Nov 2019 14:50:13 -0800 (PST)
Received: from [192.168.0.169] (cpe-67-240-36-96.nycap.res.rr.com. [67.240.36.96])
        by smtp.gmail.com with ESMTPSA id c19sm2856362qtb.30.2019.11.24.14.50.11
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Nov 2019 14:50:12 -0800 (PST)
To:     netdev@vger.kernel.org
From:   Colin Kuebler <kueblc@gmail.com>
Subject: Potential bug in ss resulting in segfault
Message-ID: <b1c5f053-178b-9ccc-4546-060f12cf2c21@gmail.com>
Date:   Sun, 24 Nov 2019 17:50:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I apologize in advance if this is the wrong place to report this, if so 
please kindly direct me to the proper place. I found this address via 
the github mirror of iproute2 at 
https://github.com/shemminger/iproute2/issues/10.

I may have come across a bug in `ss` while writing web server start up 
script that tries to check for port availability. It might also be that 
I am simply misunderstanding/misusing the tool.

I'm using the following and receiving a segfault when there is nothing 
on the specified address.

`sudo ss -Hlnp -A tcp src 0.0.0.0:80`

`ss --version` gives `ss utility, iproute2-ss180129`

`uname -a` `Linux kueblc-development 4.15.0-51-generic #55-Ubuntu SMP 
Wed May 15 14:27:21 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux`

I'd also be open to suggestions about better ways to accomplish what I'm 
trying to do, but the primary objective of this communication is to 
report the segfault to the maintainer(s).

Thanks in advance,
// kueblc

