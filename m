Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F285E7312
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 06:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiIWEkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 00:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiIWEk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 00:40:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2113.outbound.protection.outlook.com [40.107.223.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672214620E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 21:40:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwl1ym5krQskW+adp2Gq8hi/Y8O4cUeHYDDtwLBpc7JRHabfTCBe0i8ijc+ZRDckKO3Sq+tkt1BDgwYZOgL9iJWXTCdmDQv/5/p2LZsMHTGhwUKlIzqK4QxwjH0q5RmvlAJZ5LYR7g/4n2g60u4txQcQXlAN72S3JhRM2JdZbPgw/Pz1hyZMbfFIWpdYLTpM/IXr8DdWdpEl9pfbA/hVYNP1yQ/thaFGrO7RvnHdjQQFIsc8tFV62AkYOSL9I+v0CZ0m6gPyEJBo+RtSSZXzm9oKdVXub6td7XjeqiGaShYp3sc8iF0LylemL4TUTRI3daP/xSpIEKthWR2nfnBbBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xrTqK31OnJyAjK5+o8yf3bXoXp4cdqToPQWXKAOuY+A=;
 b=mPpVSlhPzLrAKLSFBngoUwmtjTUEAvwVuq9WmgIUq/SBAWJiER1kEjIittkJXRmIYxOXVPEtml/7H5K1uZhvCBgJmHaQYMwj7XsTG5R2bcls9YvLX7sg4J1s2iQxjzGiP1xK1aZIZcLKcTXA+LFZj5eyrrV8/g1bc4gEvABlp6DuP9wS0LhGkCgmPApOBkWJeGOZg5sviCunZAnPsCUiNpGZsFkwG2zQc1ySfNHtCSgge2lstGlbo9WLJ5D79EzOvRk6PyOrLG5faKqS/eO0j7e46TZ3DUvEoyJhlxjDhob9F8Bhwiob+kY3OPmZpn/kyibxnHXWEAYV6PzVzEFqew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrTqK31OnJyAjK5+o8yf3bXoXp4cdqToPQWXKAOuY+A=;
 b=S6ygaK53SswWKIVqrHwKMquzYVVoJBDGzrT1gnfvCM8o/ODziHL8P4obawseoN940Lh87Y0fA9lGgTkUS9kkx6DTYgoUhkcMbI+BkJ8iyFyuYBM9FUHE8jWmT0w82svW9lVENaayKTstugkBOes+si/gbd4cU3NP4f/LXzG6xhM=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by CO6PR13MB5370.namprd13.prod.outlook.com (2603:10b6:303:14d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Fri, 23 Sep
 2022 04:40:26 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be%6]) with mapi id 15.20.5676.009; Fri, 23 Sep 2022
 04:40:26 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: RE: [PATCH net-next 3/3] nfp: add support restart of link
 auto-negotiation
Thread-Topic: [PATCH net-next 3/3] nfp: add support restart of link
 auto-negotiation
Thread-Index: AQHYzbN6NGIRbUhLl0yJnbtzNwwnjq3sMseAgAA+W2A=
Date:   Fri, 23 Sep 2022 04:40:26 +0000
Message-ID: <DM6PR13MB37050FD20AF4529263102B52FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
        <20220921121235.169761-4-simon.horman@corigine.com>
 <20220922175453.0b7057ac@kernel.org>
In-Reply-To: <20220922175453.0b7057ac@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|CO6PR13MB5370:EE_
x-ms-office365-filtering-correlation-id: 6eb35200-71cf-42cf-740b-08da9d1dbc52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E9fE7jSs7WF6pAUBKfMFyEzNR77617iwd/zWxMIIR8h78L0WUhREG9S2lYJsjUHqtWZh7cKnWC7JiT4OgTHELkLCd3DCKsVVsBxZWOQLWoM5MbGVRuFIHgeJpD6qM4buqaay0c2WBHAivD70VXAILWgdXXIVEMyvZHOG0kn5v8fT+JDG5XSAUjjPRu3BtbBQ43eU+78RY2hc5351PFbfYGABir0Sy7H+rcPfREUlffLOoBF5SAe5AVFZSmO+2w79g+gl/r11ww6/ty2YqGD7ubYaJBK0GoK4K2ForPET4tP74ce0cBBezEtWXz+tejoNNzFS7ur7O/clRhv2v/p4A4pVnvK/6q5TazsG1uG4W9uVrrbSNtth00nZBvLWadwHVU3u3aRAII9qZqFwxmiOaUOLMHOPc2joA2DmtHihRtuocKzDRyxaRKS7nHJvAk1OoQ4+C4J86SzLjuK8pr+hWTN20mOC2JuT/S+/Jo6tS+1G33uv1ylPYCzKuyLci3lsUtmaR2rKhw0EpybibQB9kIr3G9bPkBqTwbqBTL+yl05DE1KWQ8JZ5L+4z+XaiLC5LjspiH2gjSnNVkM3dnTWB8tUVx69mMrQZcwGahmXC/30wtSpiJLEvN3zqb0gVGgZmQhBKeqmJV5eICjfysnglf63PoBa8ZYZDBrXvXELOMvSiPQqoD9liZzQp3Cz3O3FTXvKVm+Pt3ior/eMuBDtBItA5PvVpCHtkK29wDkaxbvy8sg+ffS3aQPFM5qnIMzT8eMLXpchv4+RQO2WQCgpZD4Bf+Xe2FBNNuPi0Gg48uipw20iHGAmLT7Td/ksdRXC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39830400003)(376002)(136003)(366004)(451199015)(8936002)(122000001)(38070700005)(38100700002)(6506007)(107886003)(9686003)(7696005)(2906002)(26005)(5660300002)(71200400001)(186003)(478600001)(66946007)(52536014)(54906003)(66446008)(6636002)(316002)(64756008)(86362001)(44832011)(41300700001)(66476007)(4744005)(76116006)(8676002)(4326008)(55016003)(110136005)(33656002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ws4PGKTazg+vW325YzTK/pC410cCkv8tlnWCV4ir49SinY4yJq35XI51WWTv?=
 =?us-ascii?Q?gfef8MUECbjJ37Lk9D1dlL9BvcV2E/PJWKidPO7L5ogZ35ICOqlxGjoJNn75?=
 =?us-ascii?Q?KVWlpWU9eC8xccvIlXc96GPTEJW8YBcjsN2CpGnfGKjNOVDtWXwbAAdW5iHJ?=
 =?us-ascii?Q?qMZdPz7irpffjxfiT5II/XnZ7aJXFYSBV8FMHSWtn4QY8PfJFsACq4Kidy3c?=
 =?us-ascii?Q?8ha+CFeST/btZ7jTD7qdNcyAl7WcAnVCz1FQOHpGi7zhJBfAehjyU9DPAIZ7?=
 =?us-ascii?Q?TW3l8dUipTz2DwdotvEVh63CKoHCLjW4SAEA9dexGXQmBCAhG3pivXRD6uYD?=
 =?us-ascii?Q?4beW7EcMkn3Nw5StBFmwnZP/JmMvH5alTfINvgSMr38GcD8NuH+gc2HUQH8j?=
 =?us-ascii?Q?bqpcbTb6FMI+HBrssFYMhlfdib7xDwKZB3zFCp/LamaslaQm/OyrPQABWCF4?=
 =?us-ascii?Q?odTuEJNUBCzfBdTifjfSu0rUEGYLSl341RIyFmDKqgVtIDJvMWnEs9rz/8T7?=
 =?us-ascii?Q?BRKaFHPBslVtejSPXvRhRQ2Ht/qA5TfiUjA8t/SzzEx3foFnxIgSrVoG2sVt?=
 =?us-ascii?Q?nFP2JjFlXyxIwCk2kxQwt0lnhyrzSe2O5PuPsW2FqfxxcwiFLskhE7oZp9Jp?=
 =?us-ascii?Q?p00I8a1Cy6stGugjcK9qJMFXqMvVGfCz8F7n4yDbN2NjHiqwh+4CzZ90lwDz?=
 =?us-ascii?Q?3+b371jZMMSLUJqZnj/OE0u/10bu20INDm9+M9V4P1FRWDSkCl3MYrDNGdOG?=
 =?us-ascii?Q?7OaKYS897eWKE2PAl2lfNO/78GOMXse/9lbIhZNkfH1kvQYskeuzYQ8p+OU1?=
 =?us-ascii?Q?ZMPQTlvDhmp2l4ICokTaEoUC7ltr67prJE/ES/dB2WIMZrngFbawGCC8VWkU?=
 =?us-ascii?Q?XcRTJnb9wWbBFysUZmLZQSGanofsBUJe10LO8pQ9okJgJacgGE6WUUfb5gMQ?=
 =?us-ascii?Q?ivPKqJJpiGP70m8PNVWtd2Q4pVoY/6ib0v5suIBFCr4BEEhfsbZoeSw9CEBj?=
 =?us-ascii?Q?+qhnSAXHZugu43xlFslBOOgtX1oRtgFZwwAar+T9my+dGG6czTtmr6rccTVm?=
 =?us-ascii?Q?R5joGsdoolaqWj9NJhEjjeSD+haU5L+T7HFViREyrJbRDScsUl56nsQ2Ce0l?=
 =?us-ascii?Q?L56t41faidebkdpnBwEHg7aEpVRFfYvewVUVJgXs+z4J3ClARlNn8+4lh3b8?=
 =?us-ascii?Q?tqJ/W2zMc/hcWxobVI2FwxoQsnfd0aK+aqjhe1EzEwH87E+/p7o1gDZuvvta?=
 =?us-ascii?Q?pBfBikzUj4Domv9DnQtjf5jjeNqc8swWeDxyHetYlKlqyCYeSODmlRdhUp/M?=
 =?us-ascii?Q?yFjg9ibHFSbjIdr3qRYBqCzmwMalJxMe/miPLeZQRqdlqPR2VnMPYAdTDGQG?=
 =?us-ascii?Q?F7SRTWgdeKACCYkRRvxyrIGF98sULBBz0Lb28rqGngSpR1xeQFhenqn+/0v2?=
 =?us-ascii?Q?ytvmMnxe3qqFZy30Loz/uGqWMn/4rYA+C9IDq47YszWCrPj8Sdbr65cIKY2X?=
 =?us-ascii?Q?q3XFjKAb/hRHWxlZOi1KqNNEiMwRjOpQGx334yQ10CoaA3ANjrYHEEIbUlY0?=
 =?us-ascii?Q?mN82aIlcfP8Wlx960SS7ZAFSAf04xA0GaG13M/FB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb35200-71cf-42cf-740b-08da9d1dbc52
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 04:40:26.5166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Il4/Allm4a44ObfomraRQaQcq7hLJv4ih8qwX/gk+QzCRLNZx63aR2m9HHCyJ18vzLIebZiB/dmQohABDY1fEzDWmRsvhrqEG08vHZRt7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5370
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 17:54:53 -0700 Jakub Kicinski wrote:
> On Wed, 21 Sep 2022 14:12:35 +0200 Simon Horman wrote:
> > +
> > +	netdev_info(netdev, "Link reset succeeded\n");
> > +	return 0;
>=20
> This will not do anything if the port is forced up by multi host
> or NC-SI.

OK, we're going to do the reset thing as long as it's physically
configured up.
