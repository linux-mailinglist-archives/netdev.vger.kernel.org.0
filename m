Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19F76C9387
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 11:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbjCZJaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 05:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjCZJaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 05:30:18 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2120.outbound.protection.outlook.com [40.107.101.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5007D94;
        Sun, 26 Mar 2023 02:30:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkmMDGg7Cworshp/yEl0euRmlbbZY4MvZog+EAHGz8kFi6ytiJFCzMSGD4YihxWESiHtu6sr3MqFza5Y2YAiGm9bt7tH5YHgrTOrdEhYgwnagN2iXSIVwq9j9y7SSbQJ+WVR1GYSj3aZP4CJCvxB2ajrycew6lrBgOcUL6Qxpph73N+FZVnVBIEZAXEEcPJwUilEdgIRdsqhYXTHFat2cattSxgUPvERicQ56fzrnYBaFLw7Cnbxp/9+0YqPOA2fnGMr8e+cVR04swPODcNJ43XnEj/AE4fFIbiwdiz0CzJGTkF61Bir3F9EE+7UfJkiMDE43/fNXUCwx3ab86D19w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rVxwQNBfekWdmtW5+p6mJEmdC2c4e6lQfE3bR5g4HCA=;
 b=dfCEQQoqqRf/eoFB+n5KliWg+r/flOQ9vxQ9oF4Q91xfKkMqdYq69ge00G8GSQEilOFyNMWircbYnmioH7HI1rx7r0lkf3hVVD1xH76hBia0cn/ZeIZbu+B7xnR2hlnXlDwiwSxy8e3arE75do72yFEj62uLKqsLnKkHVUQfYdp+1z6DD0U/VMpRZTwEE2fxrXiPLU+dHi5+pLN6zl2Z3rJZQ9LNpzCvI58XGcWJZyxVkdm1zCHvzvaNStqfi9Y9Q2JUs2AvRYrrOhqIfcnzFH8HRljLZfuVTj3BZkG4ikOJdyzo7CPWv8BfXcZpvRg7NNHNnv1AsXaBkhvux5r2Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVxwQNBfekWdmtW5+p6mJEmdC2c4e6lQfE3bR5g4HCA=;
 b=TVT7quFeQPwHmMi2pZwhEYavkVy/CNA/+cqeywhLDQw0Df6JSdDhcJrxqNDnYZkBMDhWZTBktvGA+yRGsEL2jTAqb+8SIabqSjBCQ9gUfC7/jHTPsGd/RLKKvqmNfalIzjI/3PjbHILLCrsKdMEv0uA3QySdistxemHs/10/Z6I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5463.namprd13.prod.outlook.com (2603:10b6:303:196::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 09:30:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 09:30:13 +0000
Date:   Sun, 26 Mar 2023 11:30:06 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org
Subject: Re: [PATCH 1/5] wifi: ath11k: Remove redundant pci_clear_master
Message-ID: <ZCAQnoXkScqT+5ob@corigine.com>
References: <20230323112613.7550-1-cai.huoqing@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323112613.7550-1-cai.huoqing@linux.dev>
X-ClientProxiedBy: AS4P250CA0016.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5463:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b7f4ba2-df0d-4a52-256d-08db2ddcb349
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kgIcjW90ClFrXwRZG78x3HOg37tNMpMr873X66MM8Lapc3nO3JFY4hQoP38KYN29V8elZ6+O86uhgAItait+iWT1U/yNCqsltuBLNQPk2QHJkRdXL24PFnYFR7qwczOYkkhwGsPlF0MIC3uZDL6W/0BdToJx4yxBehflArHj3aIOv2/lqnOm3rH+tJ/TPT7ebwCzyG3XCAgO5kjiIXWj13ltBdJZ09zy5Z1EcYiI3IMOHP9x+J+6zA5vuSZjadHbcdkUvzmWU8JwuK/FXKCkJUn4YC7BbHpg7cmYGQyZm38z9C3tesmD3IBVxwtYMk+rAPXrgb+Wg5DgR5+mW1XSk2ocY27T6NL7n/1Fwc40xcYN1hdD8+NS68hsj+sQhcWsVIWPHJeaN9sqabCnQHFwLfna0JULu/JmDPPQX+CjNIEPdE6WdGU0C+Gur53lVY6jMTPloPi5akht7uNFyxDhTjyLwlgq9Go1RA9AtJOL3ayzzxLkY31zSJ13PsvZXRapCs9Xi4If2D8PmT8kPgHpjeK5m+79BCrYJoVWVnSr5N1qtpLQyPU+9JKMzY+UodjxVxi44exgepE1R0GPuogpPyLThzyfMAgay1cWXzE93Ro=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(396003)(346002)(376002)(136003)(451199021)(478600001)(6486002)(38100700002)(66556008)(186003)(66476007)(66946007)(6666004)(6506007)(316002)(6512007)(54906003)(4744005)(7416002)(5660300002)(4326008)(8676002)(6916009)(2906002)(41300700001)(36756003)(86362001)(2616005)(8936002)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n2L8dXheKyfw6+nn6gyzbl2P+2Mc4fMpfRP5tGph/rRwCNnSMh6eonPyzci4?=
 =?us-ascii?Q?hQD5uT2hUKNB0jCRJXpNgxK7SBCqOLMGM4bSCu/bvd995Fx+msrs6dPF/U3W?=
 =?us-ascii?Q?gb1DqYIuAvPwhCeFFIkwqaEaUULbpw/Dd1OykD2cir5Y73dZtjyy+zUlmYud?=
 =?us-ascii?Q?sqDMJGCU4XpQ6cpCxpjYJ8bc9KX72AFfiXgim/KkmLFNX4OIsQPcUcc6yYRt?=
 =?us-ascii?Q?kgXjAwMADzqpoB4lik7yk6RnW/4qZ9guWlAFrI3l9njdjzF2RbY9h/dT1EdF?=
 =?us-ascii?Q?HKwGbQQJdEKByAlzQZHbMs3WQPcdHowYM8ayCKGnOlAvKKhX3WXgpebzzgTx?=
 =?us-ascii?Q?i1qVFnOcu2r5bS1TH4aAIaJh57fm48NaqD4CXPT1AnUf9WmANUGIzQGlGJpC?=
 =?us-ascii?Q?zhvWlpzfWD9DR4WlH2fgROTKqljTSzoWUOe54GfobX+NrHt2NUoNKbwy1J6p?=
 =?us-ascii?Q?yqHtvArt48SrOT29+HngvCYMqnPlLI96CAyvJjR/Sw9tllxc0jevBdFQlXfw?=
 =?us-ascii?Q?k4tdc8N+tJK2yUqgo8DWCHJ/+HCgx1iqaESeV6b6aTRmZnP1UThxttmNEnRl?=
 =?us-ascii?Q?fuIDje2VZdSG4rNn1BL/Zf3Cq8dg2ZHuxp913UyQfb7eVThjrymA4gdffM/0?=
 =?us-ascii?Q?joEFVrCPtbPDtRjeUdaokRbcZaD4hCTscYinOkjo3vAq4CWfhotLbm2cFet/?=
 =?us-ascii?Q?zdYIY4GIAE5OjeABqYo92zTd5hGkfc1RsP9mnXXVm3I0MHdopABJ2XNHjKaJ?=
 =?us-ascii?Q?S1NBiKaTuOSs8yUsXmRYw9hdaMJcPGlF/vqLVjFscTEyXa9clEWMmDEa5CA0?=
 =?us-ascii?Q?qvYK+4e7Q5NiSZt/RhwfHdzrN/xcdaZ48+2G2FMTDz/FLPX6hClMAsxiQPkP?=
 =?us-ascii?Q?OKulIa59h5hZCQBUz0kYz/r52eR3QBnjYcciUVt461UhXIejVsrTwMHklf26?=
 =?us-ascii?Q?uQqfVaeYCzQ2UjiNMEm5Y1G33RZma73WszDUOPP7TTPIxY6rCcKAdBFlOBgX?=
 =?us-ascii?Q?jgN6GaJ3kc6Cmn0oJ8sCilcjoVzocL6SEKVrX4jbdfwwAoNARbwn7BG8q1J1?=
 =?us-ascii?Q?xM4wmS/KqPXHtC6vflZ7sPvU0jntU2G2kRfTSnRFSiZdtv3MlY6IDErsmcvU?=
 =?us-ascii?Q?gf2rD6YQB8pEwIx7zCX1ZCw9N7hDJPCrcJImKsgORcd2jsKV+M2g5bcQUamH?=
 =?us-ascii?Q?BABe8h9pL+1sZPXEvkPEgA/hV4egbMdUz3o5pWn9xtNyaNTFhbFKLcSjQCGA?=
 =?us-ascii?Q?6QjO5jIVO2puKc3dyo0t76fN2xV8RzaozAjjKogVXQSEuMrxKHt8sN1JeX+r?=
 =?us-ascii?Q?E7wncKVO+OOirUPfYL3vDZ7xNrhjx7pQbaCPQqLT5/TiSFTvDsg4mBHnkQdL?=
 =?us-ascii?Q?aD5ZUfbz5pFfXsHT0uQaQf12ktTvwy7Xy0EfFkZ8zg1mqHeMOwWq5NnuJBwR?=
 =?us-ascii?Q?xwiYkAS90jLbPHEhTly7DpqnW6A7E5vXujwKfUhRwIZMtVVWJyFNbyF4EuxU?=
 =?us-ascii?Q?ySYi+YHipHvVnarYqNbqK8+Qi3vQefzOXTpQ2EFZFRGYl4RvpNMDuQTZzx9Z?=
 =?us-ascii?Q?CIug7oQJ/RkW04VS+ImN4oHDPkd7M0JRfuIMZFVKVKA8KWsPf3evY7DKTaGq?=
 =?us-ascii?Q?P20BF7nAHv+L9uAUiX1MlndZhpc49FfE8x2PynjxxF+rKipsFIX0hq4nkuDa?=
 =?us-ascii?Q?8qyAnA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7f4ba2-df0d-4a52-256d-08db2ddcb349
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 09:30:12.9036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Yrx0KIG29ACgZe0g18wkdqDnG7PgfrMoesq8kZeX48Qe0dhBOLvNnb/FXAfN/YJiIpASwCt51CMMuL7PSy/AH6v42FJNtOP9oWGuk45Dlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5463
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 07:26:09PM +0800, Cai Huoqing wrote:
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
> 	u16 pci_command;
> 
> 	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
> 	if (pci_command & PCI_COMMAND_MASTER) {
> 		pci_command &= ~PCI_COMMAND_MASTER;
> 		pci_write_config_word(dev, PCI_COMMAND, pci_command);
> 	}
> 
> 	pcibios_disable_device(dev);
> }.
> And dev->is_busmaster is set to 0 in pci_disable_device.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

