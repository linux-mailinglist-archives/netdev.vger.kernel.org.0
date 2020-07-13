Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DAA21E2E0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGMWPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:15:48 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:19712
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726149AbgGMWPf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:15:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Un3+W5eUNyHy8fh7LBqy5gM6jWotwDdGGsJgwQyNmahpFePfNIpktnO/7UlLDyPp0dOJiZLpFnma46z7TAVu58tcgfEe3agBaVm6C5jonqF0dmH6wygEK8HzPNl7nHqZJ75LM2tGNdsh00tVI08c+TXzavqbEOeiaIcKJz7RMwor9uAFu5x2hh8jVRa7+JNo7Yaqk/Nfk7n4KO25FQV/vm7VPrbmxJR+6ghIQjbAUzuFzBl9cVucEWPEozWgMSCQkiEcy3YZ+rcme9DfWFb+L4xCyDBIu26fa08ezAexKabmdFjXnwOGcwzaiZAoCGkQJr8Vf+iEq6irZOzsI+V0Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWjVI/sgV/CrwGYYT2lHS/9P02qPVlf75EOAgTz2tpk=;
 b=ZTn98YcBbX3+OzYszYmRJSL23Ik8OdCJbayJqUq/Fv9snBCq7xXHEPuABDMrYYcVVw2LqY807qsba+E+Hgs3ka+gMmeBxvNC4Pfc5bYZEH/0qzjy4iH1kuy06tGNQ+IzXcMUkhW2CI8A88YKRdHaUhPlGnishquYXTQcXFL2OHwEtcSmnR4CrfkJ7SiSgXEjN3O26YbfgLQYVLOLYPKnpYqeX3wlP6n0SzFISjJBwfWyPC2K6RmujEy5s45cOl/BOdzMocdO5ZudsgnesDmuyu6aELo+UuBCnDSL3OGorVxkGBCIaTN0aoF2/htOAYvknjNg/b4wOjG/EMWwq2ph6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWjVI/sgV/CrwGYYT2lHS/9P02qPVlf75EOAgTz2tpk=;
 b=XIWEOKDpEaPwhdOLqwDcMvH9oDPSYXRUhSdKrrJqoa7bKg8CzGccyUuHCugsVooz44+7XPqmLsi95vr00VDflIYUQqEEbPUq9PvsdPMIy7s7oqGZ1IvbgVE5/BUYE4iGmnC/1Jawe2hNhH4UMAplIpslE23Hfsj/A31VoMaDp54=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM7PR05MB6630.eurprd05.prod.outlook.com (2603:10a6:20b:141::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.24; Mon, 13 Jul
 2020 22:15:30 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::b928:e157:6570:d25b]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::b928:e157:6570:d25b%6]) with mapi id 15.20.3174.025; Mon, 13 Jul 2020
 22:15:30 +0000
Subject: Re: [PATCH] tls: add zerocopy device sendpage
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        tariqt@mellanox.com, netdev@vger.kernel.org
References: <1594550649-3097-1-git-send-email-borisp@mellanox.com>
 <20200712.153233.370000904740228888.davem@davemloft.net>
 <5aa3b1d7-ba99-546d-9440-2ffce28b1a11@mellanox.com>
 <20200713.120530.676426681031141505.davem@davemloft.net>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
Date:   Tue, 14 Jul 2020 01:15:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200713.120530.676426681031141505.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM4P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::17) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (213.57.108.142) by AM4P190CA0007.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Mon, 13 Jul 2020 22:15:29 +0000
X-Originating-IP: [213.57.108.142]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1edaa8f4-76cb-4dc0-36ef-08d8277a40e9
X-MS-TrafficTypeDiagnostic: AM7PR05MB6630:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB6630F67F01838CD3B594E5E0B0600@AM7PR05MB6630.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uFLjAaflP4gIgrgeiaFGAdFtozNJNQzfK+wSDtkbp1yZqVls7iXQKrxDOU3SrDsQ1qxOxTcdCijRJnfAgWRty9ornc9zXfu7/TFfEp0DQudNrM57jS3Ozlg7Vfxok1IGtRDZo2CWWWbJeLrBzVS9M02J/D05vTjf14GN4/ojPyaoXZvX4dNDXbUl1ixEU2ESZm4Sz4nmQMJE6qEM1ccLzu6aetFMIxr5/nXRJG8DykeaoUl4Uvs3BF93oSrPTxlFBZZKsZUI0blwbI2ammiuv2BKBUpyspOZ+Zt2lZbVfA43hu0tUQSFVORYPyaUOeKoP1QcrrXeFD+Y9ndVNjvEmcoXNEX1IyiLYfYz4N3H1VO8/zMv+mlKEv8FrwYE9jt0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(36756003)(6486002)(8676002)(53546011)(6916009)(8936002)(2906002)(186003)(2616005)(956004)(4326008)(16526019)(31696002)(6666004)(31686004)(86362001)(52116002)(478600001)(66556008)(66476007)(66946007)(316002)(5660300002)(16576012)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BlSnU6XXmet9BKkg62svl+FaOg1EYioxPScGBQHtYHbVUnqOM3kKy1g4M5qqVoaXyRXa19DOR5EGEPfC7WdBQlCnWJ7Jy3B2YO+kjLA866pyVqiCrLb3aQU3/gv/51BRzXi4/3sespbUA/yCB8iU92AsRDL24sQlIP5u9G/wLIBZj9YO/tRJn4Fte5Q1WwLHIVh4tmirIG8a4Rbzo9q/pKdfLhdBZzTo3WHxraQZXTgN74AK0Kt37JSFk/qOd6EJ6pFJO2R7179ST1iZBxv3W6jZfxC7ekF96raM3W8YaDZB8ErjiT7YTQa+0RiLhUh1RJZuSaG4GU74Zw+01SfZL3yZ3KSF+p8dgKmg9Nm6pqEzyHKRpZU4dP+63Vzj7WWsdpFcJs4T9FUpFfCNCGfcJ1t0Gnz7616LLzvf2PcCispEkO5BlmHMlmlFeA60tz7TGi/KIJ0Mkub9kdGrH1DjSJoeML2+IjVsPM+nBhSMJaY9qRs+3S+3/O2QUgpAT1AH
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1edaa8f4-76cb-4dc0-36ef-08d8277a40e9
X-MS-Exchange-CrossTenant-AuthSource: AM7PR05MB7092.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2020 22:15:30.3216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPWGq/QGeOMrd8dl9zVG0vtuQapq2gC6HFZ3w5UF6q/5kCJzhYmQ0hBXSh0b/JQw94CP5jfne09bpuGAqWyJeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6630
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/07/2020 22:05, David Miller wrote:
> From: Boris Pismenny <borisp@mellanox.com>
> Date: Mon, 13 Jul 2020 10:49:49 +0300
>
>> An alternative approach that requires no knobs is to change the
>> current TLS_DEVICE sendfile flow to skip the copy. It is really
>> not necessary to copy the data, as the guarantees it provides to
>> users, namely that users can modify page cache data sent via sendfile
>> with no error, justifies the performance overhead.
>> Users that sendfile data from the pagecache while modifying
>> it cannot reasonably expect data on the other side to be
>> consistent. TCP sendfile guarantees nothing except that
>> the TCP checksum is correct. TLS sendfile with copy guarantees
>> the same, but TLS sendfile zerocopy (with offload) will send
>> the modified data, and this can trigger an authentication error
>> on the TLS layer when inconsistent data is received. If the data
>> is inconsistent, then letting the user know via an error is desirable,
>> right?
>>
>> If there are no objections, I'd gladly resubmit it with the approach
>> described above.
> The TLS signatures are supposed to be even stronger than the protocol
> checksum, and therefore we should send out valid ones rather than
> incorrect ones.

Right, but one is on packet payload, while the other is part of the payload.

>
> Why can't the device generate the correct TLS signature when
> offloading?  Just like for the protocol checksum, the device should
> load the payload into the device over DMA and make it's calculations
> on that copy.

Right. The problematic case is when some part of the record is already
received by the other party, and then some (modified) data including
the TLS authentication tag is re-transmitted.
The modified tag is calculated over the new data, while the other party
will use the already received old data, resulting in authentication error.

>
> For SW kTLS, we must copy.  Potentially sending out garbage signatures
> in a packet cannot be an "option".
Obviously, SW kTLS must encrypt the data into a different kernel buffer,
which is the same as copying for that matter. TLS_DEVICE doesn't require this.

