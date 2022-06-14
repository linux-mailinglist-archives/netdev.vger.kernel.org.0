Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E4754A9FE
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 09:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352875AbiFNHGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 03:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352880AbiFNHGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 03:06:10 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2049.outbound.protection.outlook.com [40.107.100.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8360439152;
        Tue, 14 Jun 2022 00:06:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIE+8K7w2a8sQl/68P26ky1T/0EiZ2q8lhGp0c4AS8YraJzSFwxEJB69WTtCNe3FpN878CbWIh89brejyruWK2uL8317zlG//ayfRmBDml/8ZYxySey72AC6xTJYz6OkGIYyLxefoEQhquhFtKMxaaCUGYcgbF4Z7l7/gsoK9lua1MOgGD0CZ1mXZPF8Fcez93HGv9/h6wbRp6ylxSg0OvuO+fqjJ1ep6kaGoBpRq1K/rOdFtCuKIOShWvRbstTQUN+hrGQP6eF84Lm07NnW4XoosfNdNte4qoNU7IAuTsPcIS2flnPEh8LNA8qPWf/FiL62tZ8eiT1FuQ9yvhmULw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHlovPQM623JKq+skc9ev2nlKcbWd4ia+Ipb3nj6ZXg=;
 b=gSQGMiPI5+DDsEjsX4CdLxIMT9dsp7SS6TGU2MttPXZ2nJuHoBX0ut+a2RMbKCQohcLIq88Z3JrSZOsGm1PTtMAREwet20Uns9cOlnBBK9I9WrwPkzIw5nBzBzWEGbuF7nispmmgeM4+zNRMfPflr/svA5y7C/pQXzVqY+H/ibnv6REnoCRQ6Rjh1qh2y/17Rft+oJivSYI4wSANlKDKH9d+4eiONq+1vE66Cvh4P1G2FQpb5AeRKZjt6vQxv1IKJIB4qW62nQCYLDzPnaGsvrvbcbiKQKmsXjJj5sHrT7P0kclAiWjSDfzhvBxzN1rgF6hPh6n4/UKswFIGEjNRfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHlovPQM623JKq+skc9ev2nlKcbWd4ia+Ipb3nj6ZXg=;
 b=RH7fkMskxZicv/s7Hy2zPDGnizn2O1HgjfUenZ1Zpl1RRdy2Un0FJ9tUTOi2I9WwlMMd0r2Wonc2oGkbYH+RIpXy9cVNKJemHpfgQTbJeJtxytRF3Z9+uig/BJsU60mvBTkWBmsaNk4Uo+wttogosXiB2e57XY4qJ9ohlCylWOI=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by DM5PR12MB1835.namprd12.prod.outlook.com (2603:10b6:3:10c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.17; Tue, 14 Jun
 2022 07:06:06 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::cd5c:e903:573f:bda5]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::cd5c:e903:573f:bda5%8]) with mapi id 15.20.5332.020; Tue, 14 Jun 2022
 07:06:06 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Colin Ian King <colin.i.king@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] net: axienet: Fix spelling mistake "archecture" ->
 "architecture"
Thread-Topic: [PATCH][next] net: axienet: Fix spelling mistake "archecture" ->
 "architecture"
Thread-Index: AQHYf7qLrK3I0ppY9kGitv3iJjsf9q1OesCA
Date:   Tue, 14 Jun 2022 07:06:05 +0000
Message-ID: <MN0PR12MB5953B90BD59411B6A95A72EAB7AA9@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <20220614064647.47598-1-colin.i.king@gmail.com>
In-Reply-To: <20220614064647.47598-1-colin.i.king@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=61f19263-e0d9-44ad-9632-000001f6e3c1;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-14T07:05:18Z;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 586e34b8-3100-4620-4234-08da4dd459c1
x-ms-traffictypediagnostic: DM5PR12MB1835:EE_
x-microsoft-antispam-prvs: <DM5PR12MB1835ECE780B18506A0A9A33CB7AA9@DM5PR12MB1835.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mmaxcOEkloei3keqAWYPmsLR6QQugpne7f6YE7Lc3WgIOBSkaeLCEGiPuhfr2w7Ckm7yDoaNRRb+w98bo2WJVATtOeO4IT72FIQT7CXRzq/4nSx5iXeF6oGBFVNdty5Ozp4zLBPDMgBnbnHkL7Llc5YSsq9TrwRrP5TKkV8ALFhRiZDZs42Gzg26piPVdC6alTheOhfv/0oGAXmfuo/V4ZukLZXWmzFqq7qN8BIXWyKI8UBdRGzhU4TAN6cjoM14r/klb1dHa2HOWiUjOpXMFMwUieKNZ8vIyKOmsrCo4BcITy5wn4ErYhfeJ92VzKIjlKQYofrNMj1Bbo+Mo/xPCEvL63vTIF8yEdtzoRyHzBuzZCX0ZsPNp3gZ+Cvlh+0LAOfLPddl4F3mKJsSdmrDTmovddoIzxZEcej7/p0TD39pPlpNzlXrDXPKkH0B1IB/1t0UMztqnkGiob+JN7fV8UvBU9mbLU+HvOnxGFVdKcHR692yi+pKDM/BThCbjDm0ORbuq5gwTlpJZxv9/4sRo8dqsQMML/5xLMuxDDiFu1eP7ioKBUQhpN8jiGCo2CAftEMlL0KxuB7v5yGLJgMrh4HTndmaDrjDUtGkfoxefcJbpGSyxL0vyCtzJAOoCroHgg1JKK6sJED2WWMzJGsmGRtfxCR/JuLFlfdHjBlEl+WzQVlLdAWsEadjnrdh5+U2epNmjxdHKDFPnnKywT09Pw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(86362001)(8676002)(55016003)(4326008)(66446008)(64756008)(5660300002)(38070700005)(66476007)(76116006)(8936002)(66946007)(66556008)(52536014)(508600001)(2906002)(110136005)(33656002)(316002)(38100700002)(54906003)(71200400001)(9686003)(186003)(53546011)(6506007)(7696005)(83380400001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDhzMUw3bTFGQXhEQVR6YzRwWFhsaHJ4aitiQ3VDL05KSDZucGYwV254OEdy?=
 =?utf-8?B?MUtxbEVYenJEVFExa2ZiV3I4V0xlclIzVmNlKzAzZ01rUnh5UVNlckgyTGRi?=
 =?utf-8?B?ZFpNNDBWVFNreHYrRUdFVkt2bHY4eTJ5cHR2V0s5c2RjRjhiUXNucjRkUWlv?=
 =?utf-8?B?ekJKRDdDWkFSWmNoTjdVNEc3czFUT0oyb3lENTFBYWJid3ZQWDg0YWRmRnNk?=
 =?utf-8?B?ZmFmUG8wcFJHa01sMGh2NzdSL2pmbER5UnYzVEhEeTA3cnVhM0hEd01VaUJV?=
 =?utf-8?B?dW11RFJWaFdROXpPOVg3NHRIa2FaNkVyek5PM1ZaSFl3bFVVVXdxQ3Q5UnY5?=
 =?utf-8?B?a01ZV0gyL2dEZGFLbUwrYjRYRzVGYmp4dC9Fc0c5U3p2a0lyNkdVU3Bvc0pO?=
 =?utf-8?B?blVvV0R6Umw3SnlvTFBhS3NFOTl1K2dxVmx2ZUdiN2VEbzZIS2MwQURQMUc5?=
 =?utf-8?B?by9hM1FrWnJQWlcxNHpUcmRZWmhidzc4VnZCbjZOazlybmNMTWJZa1cxRUMv?=
 =?utf-8?B?Zng3K09nQ1pqblNJN3BwcDZ3elFVZlcwQmFSWGEzYmljd3ZZc2YrYWF4TzJF?=
 =?utf-8?B?U1g3Y3BiRmlaZWszVE5BRUxWNGVjOTR5d1BUV2NJR093d0Mrc2h2eUlNTkFN?=
 =?utf-8?B?ZGRkMEtjRk9DTmtZeWMzWXdjdWNMMzdTVDlxN1RBM1B2THZqZ05TbFFXbjEr?=
 =?utf-8?B?S0pSUkZZSFVZbTBNNHMvTGcwdGszdUNVTXhzRis3NVBUd25kYXh1b2hlbkM5?=
 =?utf-8?B?Mkh0dmdCTEV5V09nU0J6R2pmemJsemtScVJrekhNb3h6YlIyYi9vVDJCZTlV?=
 =?utf-8?B?VVVwSmg4dnhoWlUzL2c1eFNobnVldE5ScVJvU0tIamx4NVdxQVQvQnIvS3hw?=
 =?utf-8?B?MC9kdGxBR1lpRExlRnhVWWNGUy9tNzAvWU5CSXFJR0FvSTUreTlHUmRrRm9G?=
 =?utf-8?B?emsrZkMzdmdSN3AzU2t2a0hrRFFSQXVGaVZic0E4V2lldDlNUlI3bFhzWi85?=
 =?utf-8?B?WFgxQzJoZFg2REd4NGYvQnU4TmcxWGwwRzRCdk8rVGxyVFZrUkNyNWZwd1A1?=
 =?utf-8?B?NFlTZDlpRTdBWG5GQkZ1c1psU0NMdksyR3BkVmk4VlVpbUd6dkdaMmV4c09r?=
 =?utf-8?B?WE81MEZ4aS9lMG5lSmxrNTJxUWQ2a1VTRDd6aURVRFRnNnA4NEU3Nlg2eUhG?=
 =?utf-8?B?VDdjcS9IOHhqQVREVm94bjJjYk4xbFJEdzJOSEZLM1ZQTDJIWmJseGJvYlRh?=
 =?utf-8?B?Mjk4N2xqZzA4akRCTHFwUU0rTnJGaFMyYkc2dDNRVEN5V05TY1JyOGpndEU1?=
 =?utf-8?B?QTAxT0lvTkNOQ0prM1Q0TENPMWhlR2MrRWhBTWlkQUJleCs1OXo2SkpSWHk1?=
 =?utf-8?B?RytKYkRTWVdYWmVURElOOEgwUjJXemkrUHdDL0lkV3FBbUJ3ZlRBdjY0SVhD?=
 =?utf-8?B?QUxnZlRDRkdxWUNYYStTUUhJMWpjTFFvNUtoUzVzanN3QXFWYnRJYlhVTytE?=
 =?utf-8?B?c0RtSXkrdGZzOXRnS2ZQUENld3JpUU9XV3o5aWdNMVNTd3hJRW9MSnJKWEJZ?=
 =?utf-8?B?aE1TcnFzdmhQbGk2Z1dWTG1PNFM1aXY0KzBRZ3pNRWd2WmZzM0k3WGJrK3dZ?=
 =?utf-8?B?U3pYUU5PWStvRGZvTS85eUdXbWt2VEFDdlhaRjZjN2NFVGw1RUIvaldGV3F5?=
 =?utf-8?B?MjlrM3RrTDJCdFZYQjZvc0xXbVJITlB6Z2kyNUFSY0VFeVo3VGtrVnNwT1Jl?=
 =?utf-8?B?Q0ZtN0dZUlpyZ0x6Wlh3SnZ0U2FuRjNqMWc2aHc0OTdZbUFzaTE3SERLZGpo?=
 =?utf-8?B?STV1ZmtTbzZCSUxtYUZHd1UySEg4QUh1Y0dwQTIxTXBDMGl3R2dIRkFBejhy?=
 =?utf-8?B?QVpmZEVwMEpzZWsxT0lEQ3VZcGZMblRuY2VlUER6eTRORDhwUE8zU01wcGtC?=
 =?utf-8?B?bjcvNG94bmdibmhlSGVQcWVzSEx1S2ZVRk5XOXVPMXR1cksrUlh2Z3c4SmRz?=
 =?utf-8?B?WTg2VitOY2JDV0dITys4VC9uTlBPS0xVQnhCRmFrNGd1MW1BSDJ2ajcvVEdW?=
 =?utf-8?B?Q2N4YkR6NE00bTh4KzJ5dDQyaHNTMVRPZVMvQ3RoUVR4NzFub2JYRzhOVUp4?=
 =?utf-8?B?VWNweW8wVXEvRUxodEgybTBrK3lkbFZTeHNUK2E2dEhuSkNmOXFyUG5SWmNy?=
 =?utf-8?B?WmJ4YlNCb0hrQmlvZ1lrUkpORTd1TkRBRjBvZ1MzTDJTVEZ6eGdyTW1tN0hT?=
 =?utf-8?B?a0Y2OUxYUkFuUE0vV1BVZjBuNk5QM1JFMTBpdHkrWmtmdG5ySHk2U3VtK2NY?=
 =?utf-8?B?Z052TnlFVUFjL2tyQWdPaW5Vc1AzcjEzY09hbnZUbWc1MC9lL2psVkEzZUt6?=
 =?utf-8?Q?XOsiOkRmIxNfVOGC+pfBBhh8LmhPTb47t+EmiC+Mdv85i?=
x-ms-exchange-antispam-messagedata-1: ekPKdWzKsYqTzA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 586e34b8-3100-4620-4234-08da4dd459c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 07:06:06.0121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vtwyidvyrbXfxgaVbVNXO2z7hW4N/ClEA6421rkNI26/UQI8BZ+sND0WeJqq6NSa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1835
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gRnJvbTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmkua2luZ0BnbWFpbC5jb20+
DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMTQsIDIwMjIgMTI6MTcgUE0NCj4gVG86IFJhZGhleSBT
aHlhbSBQYW5kZXkgPHJhZGhleS5zaHlhbS5wYW5kZXlAeGlsaW54LmNvbT47IERhdmlkIFMgLg0K
PiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdv
b2dsZS5jb20+Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJl
bmkgPHBhYmVuaUByZWRoYXQuY29tPjsNCj4gTWljaGFsIFNpbWVrIDxtaWNoYWwuc2ltZWtAeGls
aW54LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFybS0NCj4ga2VybmVsQGxp
c3RzLmluZnJhZGVhZC5vcmcNCj4gQ2M6IGtlcm5lbC1qYW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW1BBVENIXVtuZXh0XSBu
ZXQ6IGF4aWVuZXQ6IEZpeCBzcGVsbGluZyBtaXN0YWtlICJhcmNoZWN0dXJlIiAtPg0KPiAiYXJj
aGl0ZWN0dXJlIg0KPg0KPiBDQVVUSU9OOiBUaGlzIG1lc3NhZ2UgaGFzIG9yaWdpbmF0ZWQgZnJv
bSBhbiBFeHRlcm5hbCBTb3VyY2UuIFBsZWFzZSB1c2UNCj4gcHJvcGVyIGp1ZGdtZW50IGFuZCBj
YXV0aW9uIHdoZW4gb3BlbmluZyBhdHRhY2htZW50cywgY2xpY2tpbmcgbGlua3MsIG9yDQo+IHJl
c3BvbmRpbmcgdG8gdGhpcyBlbWFpbC4NCj4NCj4NCj4gVGhlcmUgaXMgYSBzcGVsbGluZyBtaXN0
YWtlIGluIGEgZGV2X2VyciBtZXNzYWdlLiBGaXggaXQuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IENv
bGluIElhbiBLaW5nIDxjb2xpbi5pLmtpbmdAZ21haWwuY29tPg0KDQpSZXZpZXdlZC1ieTogUmFk
aGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUBhbWQuY29tPg0KDQo+IC0tLQ0K
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYyB8IDIg
Ky0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPg0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0
X21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9t
YWluLmMNCj4gaW5kZXggZmE3YmNkMmMxODkyLi44N2E2MjAwNzMwMzEgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiBA
QCAtMjAzOCw3ICsyMDM4LDcgQEAgc3RhdGljIGludCBheGllbmV0X3Byb2JlKHN0cnVjdCBwbGF0
Zm9ybV9kZXZpY2UNCj4gKnBkZXYpDQo+ICAgICAgICAgICAgICAgICB9DQo+ICAgICAgICAgfQ0K
PiAgICAgICAgIGlmICghSVNfRU5BQkxFRChDT05GSUdfNjRCSVQpICYmIGxwLT5mZWF0dXJlcyAm
DQo+IFhBRV9GRUFUVVJFX0RNQV82NEJJVCkgew0KPiAtICAgICAgICAgICAgICAgZGV2X2Vycigm
cGRldi0+ZGV2LCAiNjQtYml0IGFkZHJlc3NhYmxlIERNQSBpcyBub3QgY29tcGF0aWJsZSB3aXRo
DQo+IDMyLWJpdCBhcmNoZWN0dXJlXG4iKTsNCj4gKyAgICAgICAgICAgICAgIGRldl9lcnIoJnBk
ZXYtPmRldiwgIjY0LWJpdCBhZGRyZXNzYWJsZSBETUEgaXMgbm90IGNvbXBhdGlibGUgd2l0aA0K
PiAzMi1iaXQgYXJjaGl0ZWN0dXJlXG4iKTsNCj4gICAgICAgICAgICAgICAgIGdvdG8gY2xlYW51
cF9jbGs7DQo+ICAgICAgICAgfQ0KPg0KPiAtLQ0KPiAyLjM1LjMNCg0K
