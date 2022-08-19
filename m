Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA24599448
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345384AbiHSEvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 00:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiHSEvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 00:51:04 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EF8C6EA9;
        Thu, 18 Aug 2022 21:51:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hk/qoYYg6m363OkRWljAFTW1EFFRDQ44sBCaXKLxGWRUz0qHvpYeygc49OfBXuCj4T/ktKNaAl6jjBY2n7tua7gIUZYe7hv/peVOlVkn2RJZ4fcPOIClnF+ZPtkLunEiEO4oV8XVhuRpyYdO7zenmQbw8ErpuelqcofPZRxX9kMTaCVENh57CFAKvqs9si4LoaBmQGZtrMa/7Aka+mIY5mittshV+DFlXCJ3qkeMzxC0YEtUBWLBCICxjqzzrTeaVAE8rt5/Cq4S2NR6ews57giMSSXEYFr0YPWJeRLhbC0UqkRWwYFd3e9qPNuFxLMi6e9sHWEsI7CFwr3IY1LnrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3fC9A7DvpvQ65F2izoyBZRpDt0eKvbE/2tIvL/M5ipw=;
 b=CnXepyMdatYiz7YbQFPRVuVQIb2H47YGu4qqHqL4abJfZVIYjbK6dao16FL99xAkpVDllDXf10oF6Gv5ADh8k5RwmZRNw6Q5emCt3gsVs6jcrMSYUuCkdADew6S+wHl5XRbnVZsm8ODWhGjjswzxSWbYz5WdDCjq7x2S3KKcMQaxOOpSMcb1RvQWE1com4V5SsNOQJBNjybD+XH2O9kHFSuFyInkoq3AldqP5hgp4sala1l7eRkUrZW85ptyNAV1NCW02Gvbfz8r+VCmXZJqqYa4I1pEBdqnD7AC4y8WYaQZOBumsn0HCKJw+4bpGH9Iuw1pzSzAcBy1A3bFTO16KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fC9A7DvpvQ65F2izoyBZRpDt0eKvbE/2tIvL/M5ipw=;
 b=r9aoe1zFdsI1w/0PdQxfjWfLHwcIMg/1ILODXoG0Qmmdd6/efDLf10cF6kYsGUdazTAY8bmty+HTLyviZ9E1Is5lZwMcUDksurvBCUKWxkb+qbAZkqAG3YAS0PBDgxfFldY7VSm3uUlpqG7dkQnHkY1yNFGuUfL00Urcssi+000=
Received: from BYAPR05MB3960.namprd05.prod.outlook.com (2603:10b6:a02:88::12)
 by SN6PR05MB4848.namprd05.prod.outlook.com (2603:10b6:805:9a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.4; Fri, 19 Aug
 2022 04:49:57 +0000
Received: from BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::30dd:741a:330:383c]) by BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::30dd:741a:330:383c%3]) with mapi id 15.20.5566.004; Fri, 19 Aug 2022
 04:49:57 +0000
From:   Vishnu Dasa <vdasa@vmware.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Bryan Tan <bryantan@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 4/9] vmci/vsock: use 'target' in notify_poll_in
 callback
Thread-Topic: [RFC PATCH v3 4/9] vmci/vsock: use 'target' in notify_poll_in
 callback
Thread-Index: AQHYp0EUp9rRqTq8tUaEqfUfKAix8K2k1tiAgBDo5wA=
Date:   Fri, 19 Aug 2022 04:49:56 +0000
Message-ID: <0783F6F8-901A-4186-B4E7-01FE099F1939@vmware.com>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <2e420c8e-9550-c8c5-588f-e13b79a057ff@sberdevices.ru>
 <20220808103611.4ma4c5fpszrmstvx@sgarzare-redhat>
In-Reply-To: <20220808103611.4ma4c5fpszrmstvx@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ceacb500-2bce-42c4-f0a8-08da819e43d5
x-ms-traffictypediagnostic: SN6PR05MB4848:EE_
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3gT6Tqi+iiMJ4M4oxXa0ELbq2tv+R+HqmrCDt4JUZvBZp5n1Xcn6kPFRCxrHSQlybyChzDacCBfOQzGmnCV6iInlaJCERIvNDtCl5dKQk7rDVOOeJI+3XrZ3J5e7upXnUMXi0qDYyqEsQE3cZjmF2awsBWGRU1iReb6LaPTmDW4bUqlorl1bX793ZzqyfyV2cG/S9wfZ4tV3sZNqMX06bpG2q/PF3OQVmhc7KalWHtB9TmoFlT0PfO5kGlIf4L3s1uOOSUL+dOtAka1GL4YK8KBPVLlPUpaTjRIyIm5S/HyY5vFBqd/f62xF+bXQ5GjE0uOjYF0TrVCmEX2qDaYY6aeiuXcrkfcFFqYowUYrkCzMkfJNWrCgGXdGW5Its3SNmtutk++tzwdLIZEVjUcTwWaH1HXAUuQg/mzmHTRk+dspJJHyB38xgeumlxQRATsO0GkBQtrQKX7sd/YACm0A+5fUhxRA4HTCUfNkPmzBOF8WsBW4k4X7er9HsTSbeQxfJD9PAZB0DzXjJkffgyAaeiEN8VZp9NLk/weZ1UmDR1aj1vQchT6nbdteQOEGeXcILQ8VtseUMuUbzLdZyb9o2prNCeKQF23ex8IXpcGp1NmV66nURhxRHFCu1TXXVIY0dRJU9eRKn395BcFJsNzePk+BZBDWsRuF3DDmkXpSCoIDK/vKoBob09fRwUOuFqKqLeQhYzSoojH/kprsmcRT+lfjBU18UYjpNXDgkmWz/cgISmLpcgcnCENCMZPYeVuqIQPeIsdsz+3JuxaB/+wFJ1JwUU4KZGban2hdk0KLre9SrUFrA4XfeG7EHkitu8rFikxFs5l+IzZiosdjGxlHnLZSyf5H6qlg132D4SLogRA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB3960.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(2906002)(41300700001)(66476007)(66556008)(66946007)(6486002)(33656002)(64756008)(66446008)(8676002)(76116006)(8936002)(7416002)(5660300002)(86362001)(71200400001)(478600001)(186003)(4326008)(83380400001)(2616005)(6512007)(6506007)(53546011)(38070700005)(38100700002)(122000001)(316002)(54906003)(36756003)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9quURMd+oPAdxJ61gpQX1CEtRLOd0J6ZRXl9rKmud9ohC9aWdWgSW0/cwEKS?=
 =?us-ascii?Q?/53F+2BQwzFqA89oVM1ClhS6aJM26PReebaXHY/Rt3fsJQc6XwvjzfRIv5Dw?=
 =?us-ascii?Q?lqEifvpJia0RvK6Tfr+nLnJEi8H8MsUpizD5VdbarE86BDPrMnqkBjwamAAm?=
 =?us-ascii?Q?/a5p7JSW8aFa7lSd6DNCTq5+0oS3/96IVjNzspGT9ccf53MGdGFeaQim/bro?=
 =?us-ascii?Q?L3Bb741vWqLvFmY62+DSmCaL5sxWrIeUqE1ZRhRHXYC8AWfAp77wioBJIGEH?=
 =?us-ascii?Q?d6OoMDPo4T6lv9Z8+SiHzbAvHBy9zzP9M+bLC8+n3n6ePFUUNKXGjzjWJzb1?=
 =?us-ascii?Q?QmqVdPu/QdohNqrO6O9i3JvvAb4IJbBDwIq6jM87yeVmCJLfRtQt+j/rb0aQ?=
 =?us-ascii?Q?GTnT6hUFa1fBLFj+Jkf3ijlTCcSk20z+bx/LQ22Srgnc1t2+Ikcuws7nZZym?=
 =?us-ascii?Q?wpKjPbbeOdWSYfjdl32AdZwfpnXxgXzDCKmsSZZ844DkIVq4HhhQ1gKefPIW?=
 =?us-ascii?Q?PBgG2FjjSURvwC3upZDPq7BS950BNOAj2v9WOqvzjcwUmVwnhUO4F4bNae1A?=
 =?us-ascii?Q?qfQJocjIeq3/9j793x0eL+LATmCcQJJ3/TEC/Ge0XikRPIfRdA5X3EYg/VOf?=
 =?us-ascii?Q?7SyN+YgniB1QBd/nAMf22dMfXxLP/dQ36saHyd7jr01B8DPnO46LfZzHjHUK?=
 =?us-ascii?Q?MY0HaTpmkr1x+ZJBhS7suuOqBY5XvqjAI+JzC3OFXXztyFObdIyeLDaG/36k?=
 =?us-ascii?Q?w2lApuZr8/pOwL1p+hnAj4LF60sqBUyio9M2AKtnmv4HXa+2YU0HGpuF8iQQ?=
 =?us-ascii?Q?GisoreSqR+K7JMafco846AuzejRNOTwKQHXEpAsRbPqSu056HbweqhCCWwtO?=
 =?us-ascii?Q?wfgP5VEVUMyLUptZPaOaAotDNkAsjPwL4DU2jlGo11Wrci+lN5yJpzBnHdqW?=
 =?us-ascii?Q?Y1BvjoQDqXLCuy6NbuW6HJLswXCMg7Xheo9ytUZBIqDSENKcaEG9V06Hx1hz?=
 =?us-ascii?Q?ReLuiGxuCiovHlqcxUaxFwJ6nj/cFIJz/djTeTNuXc1VWQtqiWjHjpvSvDiK?=
 =?us-ascii?Q?DeiDOwfdNWVu7Q5q/o5MJb3sjH3Gcd4K56MUzqPj3a/2uCFZ+lu1pP7WPaDQ?=
 =?us-ascii?Q?znWnJGWjaNKk66vi+jHDkSo3V3lfu0ZrDCOU3FgvW9A9I4pTLkLU3CFxjr+C?=
 =?us-ascii?Q?zBnG4CufPsEx0FvKY89++YFdCu0ipYihLbJbjLynUrvG7u7Boh3i4gBurrPu?=
 =?us-ascii?Q?ucjQMFSTiSrBo6NFo1h9bVMn0Ex0pL8kUxpVj/yyMN1vRB74gIxKQBP74TIB?=
 =?us-ascii?Q?KdBBN4K5YHqFRriVVwsl52m4kMN5RvXA5xd48AnqDR5FP+EnmjzeAQ/9Wrsh?=
 =?us-ascii?Q?5MF4HkHuQxu2mKoA3842hPj6pmERe3Bcg5GsosEmCvFbrdsHBGi26LfGbW7U?=
 =?us-ascii?Q?Qj27IKbLYgECpDVtGGAqWqyUNIhozs6gGic7ip6uL6BNGu8G9CRuBwL0zfAC?=
 =?us-ascii?Q?TSfzTZJtZmWbgofEYAcq1oam6H3bBBMnH4ZqcMq+jw/rcqlXX/h7ix7H9pJx?=
 =?us-ascii?Q?KBtS8LS4sVkpon/dCJ6y/TfJu4FjQIN7Jn7VaDZzWAuGHE5ygQYd2PnpMdDh?=
 =?us-ascii?Q?8wGlu4lwXC3B+akXfh/sZCVDjCtQKzLnH/h6NGpZ0kPB?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E3CF2EFAF0BB8340B98B261B13DBD064@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB3960.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceacb500-2bce-42c4-f0a8-08da819e43d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 04:49:56.9100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o0B1VkB7nwXgBBoDVhcXfcWQcHjfrag3OFjQD6xb67peA2dNEHy/1gZxbScwbmQpJ/OAFYxYljdk1EgSaE1qYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4848
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Aug 8, 2022, at 3:36 AM, Stefano Garzarella <sgarzare@redhat.com> wrot=
e:
>=20
> On Wed, Aug 03, 2022 at 01:57:54PM +0000, Arseniy Krasnov wrote:
>> This callback controls setting of POLLIN,POLLRDNORM output bits of poll(=
)
>> syscall,but in some cases,it is incorrectly to set it, when socket has
>> at least 1 bytes of available data. Use 'target' which is already exists
>> and equal to sk_rcvlowat in this case.
>=20
> Ditto as the previous patch.
> With that fixed:
>=20
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>=20
> @Bryan, @Vishnu, if you're happy with this change, can you ack/review?

This patch looks good to me.

Thank you, Arseniy for running the test with VMCI.  I also ran some of
our internal tests successfully with this patch series.

> Thanks,
> Stefano
>=20
>>=20
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>

Reviewed-by: Vishnu Dasa <vdasa@vmware.com>

>> ---
>> net/vmw_vsock/vmci_transport_notify.c        | 8 ++++----
>> net/vmw_vsock/vmci_transport_notify_qstate.c | 8 ++++----
>> 2 files changed, 8 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/net/vmw_vsock/vmci_transport_notify.c b/net/vmw_vsock/vmci_=
transport_notify.c
>> index d69fc4b595ad..852097e2b9e6 100644
>> --- a/net/vmw_vsock/vmci_transport_notify.c
>> +++ b/net/vmw_vsock/vmci_transport_notify.c
>> @@ -340,12 +340,12 @@ vmci_transport_notify_pkt_poll_in(struct sock *sk,
>> {
>>      struct vsock_sock *vsk =3D vsock_sk(sk);
>>=20
>> -      if (vsock_stream_has_data(vsk)) {
>> +      if (vsock_stream_has_data(vsk) >=3D target) {
>>              *data_ready_now =3D true;
>>      } else {
>> -              /* We can't read right now because there is nothing in th=
e
>> -               * queue. Ask for notifications when there is something t=
o
>> -               * read.
>> +              /* We can't read right now because there is not enough da=
ta
>> +               * in the queue. Ask for notifications when there is some=
thing
>> +               * to read.
>>               */
>>              if (sk->sk_state =3D=3D TCP_ESTABLISHED) {
>>                      if (!send_waiting_read(sk, 1))
>> diff --git a/net/vmw_vsock/vmci_transport_notify_qstate.c b/net/vmw_vsoc=
k/vmci_transport_notify_qstate.c
>> index 0f36d7c45db3..12f0cb8fe998 100644
>> --- a/net/vmw_vsock/vmci_transport_notify_qstate.c
>> +++ b/net/vmw_vsock/vmci_transport_notify_qstate.c
>> @@ -161,12 +161,12 @@ vmci_transport_notify_pkt_poll_in(struct sock *sk,
>> {
>>      struct vsock_sock *vsk =3D vsock_sk(sk);
>>=20
>> -      if (vsock_stream_has_data(vsk)) {
>> +      if (vsock_stream_has_data(vsk) >=3D target) {
>>              *data_ready_now =3D true;
>>      } else {
>> -              /* We can't read right now because there is nothing in th=
e
>> -               * queue. Ask for notifications when there is something t=
o
>> -               * read.
>> +              /* We can't read right now because there is not enough da=
ta
>> +               * in the queue. Ask for notifications when there is some=
thing
>> +               * to read.
>>               */
>>              if (sk->sk_state =3D=3D TCP_ESTABLISHED)
>>                      vsock_block_update_write_window(sk);
>> --
>> 2.25.1
